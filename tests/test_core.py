"""Automated test suite verifying 21 CFR Part 11 and GAMP 5 compliance requirements."""

import json
from pathlib import Path
import tempfile
import unittest

from scada.audit import AuditEvent, AuditStore, utc_now
from scada.configuration import ConfigurationRegistry
from scada.security import SecurityManager
from scada.alarms import AlarmManager
from scada.store import HistorianStore, RecipeStore


class TestScadaCompliance(unittest.TestCase):
    def setUp(self):
        self.td = tempfile.TemporaryDirectory()
        self.temp_dir = Path(self.td.name)
        self.config_dir = Path(__file__).resolve().parent.parent / "scada" / "config"
        self.registry = ConfigurationRegistry(self.config_dir)

    def tearDown(self):
        self.td.cleanup()

    def test_audit_trail_cryptographic_chain(self):
        audit_store = AuditStore(self.temp_dir / "audit.db", b"TEST_KEY_32_BYTES_REQUIRED_123456")
        
        # 1. Append 3 valid events
        audit_store.append(AuditEvent(utc_now(), "operator_1", "LOGIN", "SESSION", "S1", "Logon", {}, {}, {}))
        audit_store.append(AuditEvent(utc_now(), "operator_1", "SETPOINT", "TAG", "PIC101", "Adjust vacuum", {"sp": 0}, {"sp": -400}, {}))
        audit_store.append(AuditEvent(utc_now(), "operator_1", "START", "RECIPE", "R1", "Batch Start", {}, {}, {}))
        
        valid, msg = audit_store.verify_chain()
        self.assertTrue(valid)
        self.assertIn("Verified 3 cryptographically linked", msg)

    def test_tag_catalog_range_validation(self):
        # Test valid speed
        valid, _ = self.registry.validate_value("vpu.main.agitator_speed", 45.0)
        self.assertTrue(valid)
        
        # Test out of bounds speed (>60 rpm)
        invalid, msg = self.registry.validate_value("vpu.main.agitator_speed", 120.0)
        self.assertFalse(invalid)
        self.assertIn("out of range", msg)

    def test_rbac_security_enforcement(self):
        security = SecurityManager(self.registry)
        
        # Operator can read telemetry and acknowledge alarms
        self.assertTrue(security.check_permission("operator", "telemetry.read"))
        self.assertTrue(security.check_permission("operator", "alarm.acknowledge"))
        
        # Operator CANNOT approve recipes (requires QA or Admin)
        self.assertFalse(security.check_permission("operator", "recipe.approve"))
        
        # QA CAN approve recipes
        self.assertTrue(security.check_permission("quality", "recipe.approve"))

    def test_alarm_acknowledgement_requires_comment(self):
        audit_store = AuditStore(self.temp_dir / "audit.db", b"TEST_KEY_32_BYTES_REQUIRED_123456")
        alarm_mgr = AlarmManager(self.registry, audit_store)
        
        # Trigger high temp alarm
        alarm_mgr.evaluate_telemetry({"vpu.main.temperature": 115.0})
        active = alarm_mgr.list_active()
        self.assertGreater(len(active), 0)
        alm_id = active[0]["id"]
        
        # Attempt acknowledge with empty comment -> must raise ValueError per 21 CFR Part 11
        with self.assertRaises(ValueError):
            alarm_mgr.acknowledge_alarm(alm_id, "operator_1", "")
            
        # Acknowledge with valid reason
        alarm_mgr.acknowledge_alarm(alm_id, "operator_1", "Temperature cooling valve opened manually")
    def test_cmake_and_qrc_build_integrity(self):
        root_dir = Path(__file__).resolve().parent.parent
        cmake_file = root_dir / "PVA_VPU50_SCADAContent" / "CMakeLists.txt"
        qrc_file = root_dir / "PVA_VPU50_SCADA.qrc"
        qds_cmake = root_dir / "qds.cmake"

        # 1. Check CMakeLists.txt for duplicates
        if cmake_file.exists():
            text = cmake_file.read_text(encoding="utf-8")
            import re
            qml_files = re.findall(r'"([^"]+\.qml|[^"]+\.ui\.qml)"', text)
            duplicates = [f for f in set(qml_files) if qml_files.count(f) > 1]
            self.assertEqual(len(duplicates), 0, f"Found duplicate QML files in CMakeLists.txt: {duplicates}")

        # 2. Check PVA_VPU50_SCADA.qrc for duplicates and non-existent files
        if qrc_file.exists():
            text = qrc_file.read_text(encoding="utf-8")
            import re
            files = re.findall(r'<file>([^<]+)</file>', text)
            duplicates = [f for f in set(files) if files.count(f) > 1]
            self.assertEqual(len(duplicates), 0, f"Found duplicate files in PVA_VPU50_SCADA.qrc: {duplicates}")
            for f in files:
                full_path = root_dir / f
                self.assertTrue(full_path.exists(), f"File in QRC does not exist on disk: {f}")
                self.assertFalse(f.startswith("scratch/"), f"Scratch file found in QRC: {f}")

        # 3. Check qds.cmake for scratch files
        if qds_cmake.exists():
            text = qds_cmake.read_text(encoding="utf-8")
            self.assertNotIn("scratch/", text, "qds.cmake must not contain scratch/ files")


if __name__ == "__main__":
    unittest.main()

