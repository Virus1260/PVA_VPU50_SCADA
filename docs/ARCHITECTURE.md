# PVA VPU-50 SCADA Architecture (21 CFR Part 11 & GAMP 5)

## 1. System Overview
The PVA Systems VPU-50 SCADA is structured around a strict separation of concerns between presentation and business logic:
- **Presentation Layer (QML / Qt Design Studio)**: Strict declarative UI (`.ui.qml` and `.qml`) with modular components (< 250 lines per widget).
- **Service Boundary (Python / PySide6)**: Configuration-driven controller, security manager, alarm manager, recipe state machine, and batch historian.
- **Hardware Integration Layer**: Delta AS332T-A PLC adapter over OPC UA / Modbus TCP with fallback to deterministic multi-physics plant simulator.

## 2. 21 CFR Part 11 Architecture
- **HMAC SHA-256 Audit Trail (`scada/audit.py`)**: Tamper-evident append-only cryptographic event logging where each event chains to the preceding hash.
- **Role-Based Access Control (`scada/security.py`)**: 4-level permission enforcement (Operator, Supervisor, QA, Administrator).
- **Electronic Signatures**: Dual-person authentication and mandatory reason code capture.

## 3. Screen Hierarchy
1. **Screen 1**: Process Control Dashboard (6 Rows: Stirrer, Homogenizer, Circulation, Vacuum, Suction, Heating).
2. **Screen 2**: P&ID Vector Schematic with Live Radar Minimap & Multi-Orientation Gauges.
3. **Screen 3**: Process Trends & Batch-Wise Calendar Analytics.
4. **Screen 4**: ISA-18.2 Alarm Annunciator with Mandatory Reason Logging.
5. **Screen 5**: Recipe Formulation & Automatic Execution Engine.
6. **Screen 6**: 21 CFR Part 11 Audit Trail & Electronic Batch Record (EBR).
7. **Screen 7**: Pharmaceutical Batch Report & Historical Timeline Playback.
8. **Screen 8**: Delta AS332T-A PLC Hardware I/O Diagnostics & Calibration.
