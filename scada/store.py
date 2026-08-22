"""Persistence layer for historical telemetry samples, batches, and recipe versions."""

from __future__ import annotations

from contextlib import contextmanager
from datetime import UTC, datetime
import json
from pathlib import Path
import sqlite3
from typing import Any, Iterator
from uuid import uuid4


def utc_now() -> str:
    return datetime.now(UTC).isoformat(timespec="milliseconds").replace("+00:00", "Z")


class SqliteStore:
    def __init__(self, database: Path) -> None:
        self.database = database
        database.parent.mkdir(parents=True, exist_ok=True)

    @contextmanager
    def connection(self) -> Iterator[sqlite3.Connection]:
        connection = sqlite3.connect(self.database)
        connection.row_factory = sqlite3.Row
        connection.execute("PRAGMA foreign_keys = ON")
        try:
            yield connection
            connection.commit()
        except Exception:
            connection.rollback()
            raise
        finally:
            connection.close()


class HistorianStore(SqliteStore):
    def initialise(self) -> None:
        with self.connection() as connection:
            connection.executescript(
                """
                CREATE TABLE IF NOT EXISTS batches (
                    id TEXT PRIMARY KEY,
                    recipe_id TEXT NOT NULL,
                    recipe_name TEXT NOT NULL,
                    recipe_version INTEGER NOT NULL,
                    status TEXT NOT NULL,
                    started_at_utc TEXT NOT NULL,
                    ended_at_utc TEXT,
                    initiated_by TEXT NOT NULL
                );
                CREATE TABLE IF NOT EXISTS samples (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    captured_at_utc TEXT NOT NULL,
                    batch_id TEXT,
                    tag_id TEXT NOT NULL,
                    engineering_value REAL NOT NULL,
                    quality TEXT NOT NULL,
                    FOREIGN KEY(batch_id) REFERENCES batches(id)
                );
                CREATE INDEX IF NOT EXISTS idx_samples_batch_tag_time
                    ON samples(batch_id, tag_id, captured_at_utc);
                """
            )

    def start_batch(
        self, recipe_id: str, recipe_name: str, recipe_version: int, initiated_by: str, started_at_utc: str | None = None
    ) -> dict[str, Any]:
        batch = {
            "id": f"B-{datetime.now(UTC):%Y%m%d}-{uuid4().hex[:4].upper()}",
            "recipeId": recipe_id,
            "recipeName": recipe_name,
            "recipeVersion": recipe_version,
            "status": "running",
            "startedAtUtc": started_at_utc or utc_now(),
            "endedAtUtc": None,
            "initiatedBy": initiated_by,
        }
        with self.connection() as connection:
            connection.execute(
                """INSERT INTO batches (id, recipe_id, recipe_name, recipe_version, status, started_at_utc, ended_at_utc, initiated_by)
                   VALUES (:id, :recipeId, :recipeName, :recipeVersion, :status, :startedAtUtc, :endedAtUtc, :initiatedBy)""",
                batch,
            )
        return batch

    def end_batch(self, batch_id: str, status: str, ended_at_utc: str | None = None) -> None:
        if status not in {"completed", "aborted", "released"}:
            raise ValueError("Invalid batch end status.")
        with self.connection() as connection:
            connection.execute(
                "UPDATE batches SET status = ?, ended_at_utc = ? WHERE id = ?",
                (status, ended_at_utc or utc_now(), batch_id),
            )

    def write_samples(self, batch_id: str | None, tag_values: dict[str, float], timestamp_utc: str | None = None) -> None:
        timestamp = timestamp_utc or utc_now()
        records = [
            (timestamp, batch_id, tag_id, float(val), "good")
            for tag_id, val in tag_values.items()
        ]
        with self.connection() as connection:
            connection.executemany(
                "INSERT INTO samples (captured_at_utc, batch_id, tag_id, engineering_value, quality) VALUES (?, ?, ?, ?, ?)",
                records,
            )

    def list_batches(self) -> list[dict[str, Any]]:
        with self.connection() as connection:
            rows = connection.execute("SELECT * FROM batches ORDER BY started_at_utc DESC").fetchall()
            return [
                {
                    "id": row["id"],
                    "recipeId": row["recipe_id"],
                    "recipeName": row["recipe_name"],
                    "recipeVersion": row["recipe_version"],
                    "status": row["status"],
                    "startedAtUtc": row["started_at_utc"],
                    "endedAtUtc": row["ended_at_utc"],
                    "initiatedBy": row["initiated_by"],
                }
                for row in rows
            ]

    def get_batch_telemetry(self, batch_id: str, tag_ids: list[str] | None = None) -> list[dict[str, Any]]:
        with self.connection() as connection:
            query = "SELECT captured_at_utc, tag_id, engineering_value FROM samples WHERE batch_id = ?"
            params: list[Any] = [batch_id]
            if tag_ids:
                query += f" AND tag_id IN ({','.join(['?']*len(tag_ids))})"
                params.extend(tag_ids)
            query += " ORDER BY captured_at_utc ASC"
            rows = connection.execute(query, params).fetchall()
            return [
                {
                    "time": row["captured_at_utc"],
                    "tag": row["tag_id"],
                    "value": row["engineering_value"],
                }
                for row in rows
            ]


class RecipeStore(SqliteStore):
    def initialise(self) -> None:
        with self.connection() as connection:
            connection.execute(
                """
                CREATE TABLE IF NOT EXISTS recipes (
                    id TEXT NOT NULL,
                    version INTEGER NOT NULL,
                    name TEXT NOT NULL,
                    status TEXT NOT NULL,
                    payload_json TEXT NOT NULL,
                    created_at_utc TEXT NOT NULL,
                    created_by TEXT NOT NULL,
                    approved_at_utc TEXT,
                    approved_by TEXT,
                    PRIMARY KEY (id, version)
                )
                """
            )

    def save_recipe(self, recipe_id: str, version: int, name: str, payload: dict[str, Any], created_by: str) -> None:
        with self.connection() as connection:
            connection.execute(
                """
                INSERT OR REPLACE INTO recipes (
                    id, version, name, status, payload_json, created_at_utc, created_by
                ) VALUES (?, ?, ?, 'approved', ?, ?, ?)
                """,
                (recipe_id, version, name, json.dumps(payload), utc_now(), created_by),
            )

    def list_recipes(self) -> list[dict[str, Any]]:
        with self.connection() as connection:
            rows = connection.execute("SELECT * FROM recipes ORDER BY id ASC, version DESC").fetchall()
            return [
                {
                    "id": row["id"],
                    "version": row["version"],
                    "name": row["name"],
                    "status": row["status"],
                    "payload": json.loads(row["payload_json"]),
                    "createdAtUtc": row["created_at_utc"],
                    "createdBy": row["created_by"],
                }
                for row in rows
            ]
