"""21 CFR Part 11 Tamper-Evident Cryptographic Audit Trail.

Implements an append-only event stream where every record is hashed with HMAC SHA-256
and cryptographically chained to the previous record's hash.
"""

from __future__ import annotations

from contextlib import contextmanager
from dataclasses import dataclass
from datetime import UTC, datetime
import hashlib
import hmac
import json
from pathlib import Path
import sqlite3
from typing import Any, Iterator


GENESIS_HASH = "0" * 64


def utc_now() -> str:
    return datetime.now(UTC).isoformat(timespec="milliseconds").replace("+00:00", "Z")


def canonical_json(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"), default=str)


@dataclass(frozen=True)
class AuditEvent:
    timestamp_utc: str
    actor_id: str
    action: str
    object_type: str
    object_id: str
    reason: str
    before: Any
    after: Any
    context: Any


class AuditStore:
    """Append-only 21 CFR Part 11 audit storage with cryptographic integrity chaining."""

    def __init__(self, database: Path, chain_key: bytes) -> None:
        if len(chain_key) < 16:
            raise ValueError("Audit-chain key must contain at least 16 bytes.")
        self.database = database
        self.chain_key = chain_key
        database.parent.mkdir(parents=True, exist_ok=True)
        self._initialise()

    @contextmanager
    def _connection(self) -> Iterator[sqlite3.Connection]:
        connection = sqlite3.connect(self.database)
        connection.row_factory = sqlite3.Row
        try:
            yield connection
            connection.commit()
        except Exception:
            connection.rollback()
            raise
        finally:
            connection.close()

    def _initialise(self) -> None:
        with self._connection() as connection:
            connection.execute(
                """
                CREATE TABLE IF NOT EXISTS audit_events (
                    sequence INTEGER PRIMARY KEY AUTOINCREMENT,
                    timestamp_utc TEXT NOT NULL,
                    actor_id TEXT NOT NULL,
                    action TEXT NOT NULL,
                    object_type TEXT NOT NULL,
                    object_id TEXT NOT NULL,
                    reason TEXT NOT NULL,
                    before_json TEXT NOT NULL,
                    after_json TEXT NOT NULL,
                    context_json TEXT NOT NULL,
                    previous_hash TEXT NOT NULL,
                    record_hash TEXT NOT NULL UNIQUE
                )
                """
            )

    def append(self, event: AuditEvent) -> int:
        payload = {
            "timestamp_utc": event.timestamp_utc,
            "actor_id": event.actor_id,
            "action": event.action,
            "object_type": event.object_type,
            "object_id": event.object_id,
            "reason": event.reason,
            "before": event.before,
            "after": event.after,
            "context": event.context,
        }
        with self._connection() as connection:
            row = connection.execute(
                "SELECT record_hash FROM audit_events ORDER BY sequence DESC LIMIT 1"
            ).fetchone()
            previous_hash = row["record_hash"] if row else GENESIS_HASH
            hasher = hmac.new(self.chain_key, digestmod=hashlib.sha256)
            hasher.update(previous_hash.encode("utf-8"))
            hasher.update(canonical_json(payload).encode("utf-8"))
            record_hash = hasher.hexdigest()

            cursor = connection.execute(
                """
                INSERT INTO audit_events (
                    timestamp_utc, actor_id, action, object_type, object_id,
                    reason, before_json, after_json, context_json,
                    previous_hash, record_hash
                ) VALUES (
                    ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
                )
                """,
                (
                    event.timestamp_utc,
                    event.actor_id,
                    event.action,
                    event.object_type,
                    event.object_id,
                    event.reason,
                    canonical_json(event.before),
                    canonical_json(event.after),
                    canonical_json(event.context),
                    previous_hash,
                    record_hash,
                ),
            )
            return int(cursor.lastrowid)

    def verify_chain(self) -> tuple[bool, str]:
        with self._connection() as connection:
            rows = connection.execute(
                "SELECT * FROM audit_events ORDER BY sequence ASC"
            ).fetchall()
            expected_previous = GENESIS_HASH
            for row in rows:
                if row["previous_hash"] != expected_previous:
                    return False, f"Broken chain at sequence {row['sequence']}: mismatched previous hash"
                payload = {
                    "timestamp_utc": row["timestamp_utc"],
                    "actor_id": row["actor_id"],
                    "action": row["action"],
                    "object_type": row["object_type"],
                    "object_id": row["object_id"],
                    "reason": row["reason"],
                    "before": json.loads(row["before_json"]),
                    "after": json.loads(row["after_json"]),
                    "context": json.loads(row["context_json"]),
                }
                hasher = hmac.new(self.chain_key, digestmod=hashlib.sha256)
                hasher.update(expected_previous.encode("utf-8"))
                hasher.update(canonical_json(payload).encode("utf-8"))
                expected_record_hash = hasher.hexdigest()
                if row["record_hash"] != expected_record_hash:
                    return False, f"Tampered record at sequence {row['sequence']}: hash signature mismatch"
                expected_previous = row["record_hash"]
        return True, f"Verified {len(rows)} cryptographically linked audit records"

    def list_events(self, limit: int = 200, actor_id: str | None = None) -> list[dict[str, Any]]:
        with self._connection() as connection:
            query = "SELECT * FROM audit_events"
            params = []
            if actor_id:
                query += " WHERE actor_id = ?"
                params.append(actor_id)
            query += " ORDER BY sequence DESC LIMIT ?"
            params.append(limit)
            rows = connection.execute(query, params).fetchall()
            return [
                {
                    "sequence": row["sequence"],
                    "timestamp_utc": row["timestamp_utc"],
                    "actor_id": row["actor_id"],
                    "action": row["action"],
                    "object_type": row["object_type"],
                    "object_id": row["object_id"],
                    "reason": row["reason"],
                    "before": json.loads(row["before_json"]),
                    "after": json.loads(row["after_json"]),
                    "context": json.loads(row["context_json"]),
                    "record_hash": row["record_hash"][:12] + "...",
                }
                for row in rows
            ]
