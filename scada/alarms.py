"""ISA-18.2 Alarm Management and Annunciation Engine."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from typing import Any
from scada.audit import AuditEvent, AuditStore, utc_now
from scada.configuration import ConfigurationRegistry


@dataclass
class ActiveAlarm:
    id: str
    tag_id: str
    severity: str
    title: str
    operator_response: str
    triggered_at_utc: str
    current_value: float
    setpoint: float
    acknowledged: bool = False
    acknowledged_by: str | None = None
    acknowledged_at_utc: str | None = None
    acknowledge_comment: str | None = None


class AlarmManager:
    def __init__(self, registry: ConfigurationRegistry, audit_store: AuditStore) -> None:
        self.registry = registry
        self.audit_store = audit_store
        self._active_alarms: dict[str, ActiveAlarm] = {}

    def evaluate_telemetry(self, telemetry: dict[str, float]) -> list[ActiveAlarm]:
        alarm_defs = self.registry.alarms.get("alarms", [])
        for ad in alarm_defs:
            alm_id = ad["id"]
            tag_id = ad["tag_id"]
            if tag_id not in telemetry:
                continue
            val = telemetry[tag_id]
            tag = self.registry.get_tag(tag_id)
            if not tag:
                continue

            limits = tag.get("limits", {})
            thresh_key = ad.get("threshold_key")
            threshold = limits.get(thresh_key, 0.0) if thresh_key else 0.0

            is_triggered = False
            cond = ad.get("condition", "high")
            if cond == "high" and val >= threshold:
                is_triggered = True
            elif cond == "low" and val <= threshold:
                is_triggered = True

            if is_triggered and alm_id not in self._active_alarms:
                alm = ActiveAlarm(
                    id=alm_id,
                    tag_id=tag_id,
                    severity=ad["severity"],
                    title=ad["title"],
                    operator_response=ad["operator_response"],
                    triggered_at_utc=utc_now(),
                    current_value=val,
                    setpoint=threshold,
                )
                self._active_alarms[alm_id] = alm
                self.audit_store.append(
                    AuditEvent(
                        timestamp_utc=alm.triggered_at_utc,
                        actor_id="SYSTEM",
                        action="ALARM_TRIGGERED",
                        object_type="ALARM",
                        object_id=alm_id,
                        reason=ad["title"],
                        before={"state": "NORMAL"},
                        after={"state": "ALARM", "value": val, "threshold": threshold},
                        context={"severity": ad["severity"], "tag_id": tag_id},
                    )
                )
            elif not is_triggered and alm_id in self._active_alarms:
                # Clear automatically if acknowledged, or keep in unacked state
                if self._active_alarms[alm_id].acknowledged:
                    del self._active_alarms[alm_id]

        return list(self._active_alarms.values())

    def acknowledge_alarm(self, alarm_id: str, actor_id: str, comment: str) -> None:
        if alarm_id not in self._active_alarms:
            return
        if not comment or len(comment.strip()) < 3:
            raise ValueError("21 CFR Part 11 requires a non-empty reason comment to acknowledge an alarm.")

        alm = self._active_alarms[alarm_id]
        alm.acknowledged = True
        alm.acknowledged_by = actor_id
        alm.acknowledged_at_utc = utc_now()
        alm.acknowledge_comment = comment

        self.audit_store.append(
            AuditEvent(
                timestamp_utc=alm.acknowledged_at_utc,
                actor_id=actor_id,
                action="ALARM_ACKNOWLEDGED",
                object_type="ALARM",
                object_id=alarm_id,
                reason=comment,
                before={"acknowledged": False},
                after={"acknowledged": True, "comment": comment},
                context={"tag_id": alm.tag_id, "severity": alm.severity},
            )
        )

    def list_active(self) -> list[dict[str, Any]]:
        return [
            {
                "id": a.id,
                "tagId": a.tag_id,
                "severity": a.severity,
                "title": a.title,
                "response": a.operator_response,
                "triggeredAtUtc": a.triggered_at_utc,
                "value": a.current_value,
                "setpoint": a.setpoint,
                "acknowledged": a.acknowledged,
                "acknowledgedBy": a.acknowledged_by,
                "comment": a.acknowledge_comment,
            }
            for a in self._active_alarms.values()
        ]
