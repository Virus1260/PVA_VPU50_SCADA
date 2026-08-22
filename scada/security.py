"""21 CFR Part 11 Role-Based Access Control and Permission Security."""

from __future__ import annotations

from typing import Any
from scada.configuration import ConfigurationRegistry


class SecurityManager:
    def __init__(self, registry: ConfigurationRegistry) -> None:
        self.registry = registry

    def check_permission(self, role_id: str, required_permission: str) -> bool:
        if not required_permission:
            return True
        role = self.registry.get_role(role_id)
        if not role:
            return False
        permissions = set(role.get("permissions", []))
        return required_permission in permissions

    def enforce(self, actor_id: str, role_id: str, permission: str, action_desc: str) -> None:
        if not self.check_permission(role_id, permission):
            raise PermissionError(
                f"User '{actor_id}' with role '{role_id}' is not authorized to execute '{action_desc}'. "
                f"Required permission: '{permission}'"
            )
