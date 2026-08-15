# PVA Systems VPU-50 Industrial SCADA – Agent Directives & Rules

## 1. Core Engineering & Safety Rules
1. **Strict Git Rule**: NEVER run `git commit` or `git push` automatically without explicit user permission.
2. **Process Running Safety Interlock**:
   - While any equipment row is actively running (`isPlaying == true`), its speed setpoint, steppers (`+`/`−`), and mode selector modal MUST be locked.
   - Attempting parameter edits while running must trigger an annunciator alert: `"SAFETY INTERLOCK: Stop [Equipment] before modifying mode or setpoint parameters."`
3. **Mandatory Valve Confirmation Interlock**:
   - External Line Recirculation, CIP modes, and Suction charging modes MUST trigger `ConfirmationModal` with the 5-column Valve Status Matrix.
   - The `CONFIRM POSITIONING` button unlocks ONLY after all required manual butterfly valves (`V301`, `V302`, `V303`) are checked by the operator.
4. **Slint & QML Design Standards**:
   - Header Bar: Standardized at `86px` height. Machine capsule on the left, Centered Alarm/Annunciator Box with `Ack` button, Right-aligned User Profile, Digital Clock, and PVA Systems vector logo.
   - Numeric Keypad: 4×4 Grid layout (`7,8,9,Del` | `4,5,6,Esc` | `1,2,3,Clear` | `0,.,−,OK`).

---

## 2. Visual Design Language
- **Background**: `#08213b` / Deep Industrial Navy
- **Cards & Compartments**: `#0a2e50` / `#0c345a` / `#154d80`
- **Borders & Dividers**: `#1d5b94` / `#1e40af`
- **Active Green**: `#78dc20` / `#22c55e`
- **Active Cyan Needles**: `#00d2ff` / `#38bdf8`
- **Alarm / Fault Red**: `#ff4444` / `#dc2626`
- **Warning Amber**: `#f59e0b` / `#f5d033`
- **OEM Identity**: PVA Systems (Machine Model: **VPU 50** Batch Mixing Skid).
