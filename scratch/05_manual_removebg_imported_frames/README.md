# 05 - Manual Remove.bg Frames Import & Vectorization Pipeline

This pipeline imports the background-removed PNG frames processed via remove.bg from:
`C:\Users\Shekhar\Downloads\11\`

---

## Folder Organization

1. **`01_source_removebg_png/`**:
   - Exact copy of all 36 source images from `C:\Users\Shekhar\Downloads\11\`.
2. **`02_cropped_resized_png/`**:
   - Bounding-box cropped and normalized to standard 480x560 high-definition resolution (`agitator_frame_00.png` to `agitator_frame_35.png`).
3. **`03_vector_svg_frames/`**:
   - High-fidelity vector SVGs generated via `vtracer` and deployed to [`PVA_VPU50_SCADAContent/assets/agitator_sequence/`](../../PVA_VPU50_SCADAContent/assets/agitator_sequence/).

---

## Execution Guide

```powershell
# 1. Activate shared environment
..\.venv\Scripts\Activate.ps1

# 2. Run import and vectorization
python import_removebg_frames_to_svg.py
```
