"""Catalogue loaders and configuration validation."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any


class ConfigurationRegistry:
    def __init__(self, config_dir: Path) -> None:
        self.config_dir = config_dir
        self.tags = self._load_json(config_dir / "tag_catalog.json")
        self.roles = self._load_json(config_dir / "role_catalog.json")
        self.alarms = self._load_json(config_dir / "alarm_catalog.json")
        self._tag_map = {t["id"]: t for t in self.tags.get("tags", [])}
        self._role_map = {r["id"]: r for r in self.roles.get("roles", [])}

    def _load_json(self, path: Path) -> dict[str, Any]:
        if not path.exists():
            return {}
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)

    def get_tag(self, tag_id: str) -> dict[str, Any] | None:
        return self._tag_map.get(tag_id)

    def get_role(self, role_id: str) -> dict[str, Any] | None:
        return self._role_map.get(role_id)

    def validate_value(self, tag_id: str, value: float) -> tuple[bool, str]:
        tag = self.get_tag(tag_id)
        if not tag:
            return False, f"Tag '{tag_id}' not found in catalogue"
        limits = tag.get("limits", {})
        min_val = limits.get("minimum", -1e9)
        max_val = limits.get("maximum", 1e9)
        if not (min_val <= value <= max_val):
            return False, f"Value {value} out of range [{min_val}, {max_val}] for tag {tag_id}"
        return True, "Valid"
