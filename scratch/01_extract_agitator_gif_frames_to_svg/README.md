# 01 - Agitator GIF Frame Extraction & Vectorization Pipeline

This tool was the initial iteration created to extract animation frames from the source GIF (`My Video-1.gif`), filter hold/duplicate frames across 360°, and convert them into SVG assets.

---

## Technical Context & Method

- **Input Media**: `C:\Users\Shekhar\Videos\My Video-1.gif` (28 raw frames, 646x770 resolution)
- **Mathematical Frame Comparison**: Computed Root Mean Square (RMS) difference matrices across consecutive frames to detect 18 distinct rotational keyframes (removing 10 hold/pause frames).
- **Segmentation Method**: Classical luminance and color-distance thresholding with Pillow and OpenCV.
- **Vector Engine**: Rust-based `vtracer` converting transparent PNGs into SVGs.

---

## Classical Thresholding Limitations Discovered

1. **Specular Highlight Blind Spot**:
   - The GIF had an off-white background (`#FFFFFF` / `#F8F8F8`).
   - When the metallic agitator blades rotated, specular reflection highlights on the arms and shaft reached brightness levels near `#FFFFFF`.
   - Classical luminance thresholding (`luminance > 220`) could not distinguish white background from bright chrome highlights, causing light-reflecting metallic arms to become partially transparent.
2. **Quantization Noise in 8-Bit Palettes**:
   - GIF format's 256-color palette caused micro-dithering along the blade edges, creating minor contour jitter when vectorized.

---

## Execution Guide

```powershell
# 1. Activate the shared scratch virtual environment
..\.venv\Scripts\Activate.ps1

# 2. Run the extraction and vectorization pipeline
python extract_frames_to_svg.py --export-scada

# 3. Validate rotational distinctness
python compare_frames.py
```
