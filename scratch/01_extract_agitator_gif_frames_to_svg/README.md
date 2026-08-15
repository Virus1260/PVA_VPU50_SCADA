# 01 - Agitator GIF Frame Extraction & SVG Vectorization Pipeline

This automated tool extracts individual animation frames from an agitator animation GIF (`My Video-1.gif`), processes each frame to make the background transparent, and converts/vectorizes each frame into high-fidelity SVG and high-resolution PNG assets for industrial SCADA HMI animation.

---

## Prerequisites & Environment Setup

Use the project's shared virtual environment located in `scratch/.venv`:

```powershell
# 1. Activate the virtual environment
..\.venv\Scripts\Activate.ps1

# 2. Install required dependencies
pip install -r requirements.txt
```

---

## How to Run

Run the Python extraction script:

```powershell
# Run with default GIF path (C:\Users\Shekhar\Videos\My Video-1.gif)
python extract_frames_to_svg.py

# Or specify a custom GIF path and output directory:
python extract_frames_to_svg.py --gif-path "C:\Users\Shekhar\Videos\My Video-1.gif" --export-scada
```

---

## Features

1. **Alpha Background Separation**:
   - Removes solid/off-white background colors (`#FFFFFF` and yellowish compression artifacts) while retaining the full metallic detail and shading of the agitator impeller blades and shaft.
2. **Dual-Format Asset Generation**:
   - **SVG (`.svg`)**: Crisp, infinitely scalable vector curves generated via Rust-based `vtracer` engine.
   - **PNG (`.png`)**: Pixel-perfect transparent raster frames.
3. **Automated SCADA Deployment**:
   - Copies generated assets directly into `PVA_VPU50_SCADAContent/assets/agitator_sequence/`.
   - Generates a frame sequence manifest `agitator_sequence.json`.

---

## File Structure

```
01_extract_agitator_gif_frames_to_svg/
├── README.md                  # Documentation and execution guide
├── requirements.txt           # Python dependencies
├── extract_frames_to_svg.py   # Main extraction and vectorization script
└── output_frames/             # Generated frame outputs
    ├── png/                   # Transparent PNG frames (00..27)
    └── svg/                   # Vectorized SVG frames (00..27)
```
