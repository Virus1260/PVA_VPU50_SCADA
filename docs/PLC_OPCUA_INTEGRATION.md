# Delta AS332T-A PLC Integration Guide

## 1. Hardware Architecture
- **PLC**: Delta AS332T-A Compact Modular Mid-Range PLC
- **CPU**: 32-bit SoC, 16 Digital Inputs (DI), 16 Transistor NPN Outputs (DO)
- **Expansion Modules**: 8 Analog Inputs (AI), 4 Analog Outputs (AO)
- **Communication Protocol**: OPC UA / Modbus TCP over Industrial Ethernet

## 2. Tag Mapping Reference
All tags are configured in `scada/config/tag_catalog.json`.

| Signal Tag | Parameter | Units | Range | Modbus Address | OPC UA Node ID |
|---|---|---|---|---|---|
| `vpu.main.temperature` | Product Temp | °C | 0 - 150 | 40001 | `ns=2;s=VPU.Main.Temperature` |
| `vpu.jacket.temperature` | Jacket Temp | °C | 0 - 160 | 40002 | `ns=2;s=VPU.Jacket.Temperature` |
| `vpu.main.vacuum_pressure` | Headspace Vacuum | mbar | -1000 - 500 | 40003 | `ns=2;s=VPU.Main.VacuumPressure` |
| `vpu.main.agitator_speed` | Agitator RPM | rpm | 0 - 60 | 40004 | `ns=2;s=VPU.Main.Agitator.Speed` |
| `vpu.main.homogenizer_speed` | Homogenizer RPM | rpm | 0 - 6000 | 40005 | `ns=2;s=VPU.Main.Homogenizer.Speed` |
| `vpu.main.weight` | Gross Weight | kg | 0 - 200 | 40006 | `ns=2;s=VPU.Main.Weight` |
| `vpu.main.level` | Fill Level | % | 0 - 100 | 40007 | `ns=2;s=VPU.Main.Level` |
| `vpu.heater.power` | Heater Power | % | 0 - 100 | 40008 | `ns=2;s=VPU.Heater.Power` |
| `vpu.seal.temperature` | Seal Fluid Temp | °C | 0 - 100 | 40009 | `ns=2;s=VPU.Seal.Temperature` |
| `vpu.seal.pressure` | Seal Barrier Press | bar | 0 - 6 | 40010 | `ns=2;s=VPU.Seal.Pressure` |

## 3. Switching from Simulation to Production PLC
To switch from simulation to the real Delta PLC:
1. Update `scada/config/opcua.production.example.json` with the PLC IP address and credentials.
2. Launch the backend with `--adapter delta_opcua`.
