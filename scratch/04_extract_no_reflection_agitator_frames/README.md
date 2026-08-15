# 04 - No-Reflection Agitator GrabCut Extraction & Vectorization Pipeline

This pipeline processes the 3D model screen recording with **specular reflections turned off** (`Screen Recording 2026-08-16 032628.mp4`) and utilizes **OpenCV GrabCut Graph-Cut Energy Minimization** for high-precision background removal.

---

## 3-Stage Directory Architecture

1. **`01_raw_video_frames/`**:
   - Exact raw keyframes extracted directly from the video stream without any alterations or compression loss (`raw_frame_00.png` to `raw_frame_35.png`).
2. **`02_transparent_bg_frames/`**:
   - High-definition transparent PNGs processed with GrabCut graph-cut segmentation, tight bounding-box cropping, and sub-pixel edge smoothing (`agitator_frame_00.png` to `agitator_frame_35.png`).
3. **`03_vector_svg_frames/`**:
   - Vectorized SVG assets generated via `vtracer` and deployed to the SCADA HMI asset bundle (`agitator_frame_00.svg` to `agitator_frame_35.svg`).

---

## Why GrabCut Energy Minimization Succeeded

- **Gaussian Mixture Models (GMM)**:
  - GrabCut models both foreground metal and background canvas as full color covariance distributions (5 GMM components each).
- **Graph-Cut Optimization**:
  - Solves the max-flow/min-cut problem over the pixel graph, finding the global minimum energy boundary between the metallic agitator and ambient lighting gradients.
- **Internal Cavities & Hollow Loops**:
  - Transparently clears internal negative spaces between curved blades, scraper brackets, and the shaft with zero background bleeding.

---

## Execution Guide

```powershell
# 1. Activate shared environment
..\.venv\Scripts\Activate.ps1

# 2. Run the 3-stage GrabCut pipeline
python extract_no_reflection_frames_to_svg.py --frame-count 36 --export-scada
```
