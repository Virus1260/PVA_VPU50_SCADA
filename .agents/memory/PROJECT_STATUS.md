# PVA Systems VPU-50 – Agent Handoff Memory & System Architecture

> **IMPORTANT FOR ANY AI AGENT:** Read this document at the start of every session before modifying any code or project configuration.

---

## 1. Project Identity

| Parameter | Specification |
| :--- | :--- |
| **System Name** | PVA Systems VPU 50 Industrial SCADA System |
| **OEM Standard** | EKATO EPOS SCADA Standards (UNIMIX 50 Batch Mixing Skid) |
| **Framework** | Qt 6 Quick / QML + C++ CMake |
| **Resolution Target** | 1280×720 / 1920×1080 Responsive HMI Touch Panel |
| **PLC Interface** | Delta AS332T-A via OPC UA / Modbus TCP |
| **Workspace** | `C:\Users\Shekhar\Desktop\QT DESIGNER PROJECTS\PVA_VPU50_SCADA` |

---

## 2. Screen Architecture Map

| Screen File | Name | Description |
| :--- | :--- | :--- |
| `Screen_1_Control.ui.qml` | Control Dashboard | 6-Row Tabular Process Overview (Agitator, Homogenizer, External Line, Vacuum, Suction, Heating) |
| `Screen_2_P_ID.qml` | P&ID Schematic | Interactive P&ID with vessel heads, jackets, valve flow animations, and 24-frame PARAVISC rotation |
| `Screen_3_Trends.qml` | Process Trends | Multi-channel real-time and historical telemetry chart recorder |
| `Screen_4_Alarms.qml` | Alarms & Events | ISA-18.2 compliant alarm list with priority badges, timestamping, and ACK handling |
| `Screen_5_Recipes.qml` | Recipe Manager | Batch recipe phase sequencer with parameter setpoints |
| `Screen_6_Audit.qml` | Audit Trail | 21 CFR Part 11 electronic batch record with operator e-signatures |
| `Screen_7_Playback.qml` | Process Playback | Historical batch replay with scrubber and variable playback speed |
| `Screen_8_Diagnostics.qml`| Maintenance & I/O | Hardware I/O testing, sensor calibration, and manual PLC override |

---

## 3. Modal Architecture

- **`NumericKeypadModal.qml`**: 4×4 Touch Keypad with `Del`, `Esc`, `Clear`, `−`, and `OK`.
- **`ConfirmationModal.qml`**: 5-column Valve Status Matrix and mandatory safety interlock for manual butterfly valves.
- **`PlantModeModal.qml`**: Plant-level Automatic `(A)` vs Manual `(M)` mode toggle and recipe routing.
- **`AgitatorModeModal.qml`**: CCW, CW, and Reversing agitation modes.
- **`HomogenizerModeModal.qml`**: Permanent and Interval homogenization modes.
- **`VacuumModeModal.qml`**: Continuous, Vacuum Level Setpoint, and Material Loading modes.
- **`ExternalLineModeModal.qml`**: Product Discharge, Recirculation Loop, CIP Rinse, CIP Discharge, CIP Drying.
- **`FillingModeModal.qml`**: Liquid Port, Solids Funnel, and Bottom Suction charging.
- **`HeatingModeModal.qml`**: Heating/Cooling, Jacket/Product regulation, Baffle/Homogenizer temperature source.

---

## 4. Equipment Tag Reference (VPU 50)

### Manufacturing Vessel (1B1001)
- `1M1501`: Helical Anchor Stirrer Motor
- `1M2003`: Bottom Rotor-Stator Homogenizer Motor
- `1M2001`: Discharge Centrifugal Pump Motor
- `1M4001`: Vessel Lid Hydraulic Lift
- `1M5001`: Liquid Ring Vacuum Pump Motor
- `1M6001`: Recirculation Loop Pump Motor
- `1E6001`: Jacket Electric Heating Element
- `1T1001`: Product Temperature Transmitter (°C)
- `1P1001`: Vessel Pressure Transmitter (mbar)

### Valve Matrix Reference
- `V101`: Main Vessel Discharge Valve (Solenoid - Auto)
- `V102`: External Circulation Return Valve (Solenoid - Auto)
- `V103`: Recirculation Divert Valve (Solenoid - Auto)
- `V201`: CIP Rinse Water Valve (Solenoid - Auto)
- `V202`: CIP Drain Discharge Valve (Solenoid - Auto)
- `V203`: CIP Air Drying Valve (Solenoid - Auto)
- `V301`: Liquid Port Charging Valve (Manual Butterfly)
- `V302`: Solids Funnel Charging Valve (Manual Butterfly)
- `V303`: Bottom Suction Valve (Manual Butterfly)
