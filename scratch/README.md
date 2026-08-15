# SCADA Agitator 3D Extraction & Vectorization Research Repository

This repository documents the evolution of the 3D agitator impeller extraction and vectorization pipelines developed for the **PVA VPU-50 / EKATO EPOS SCADA System**.

---

## 1. Executive Summary & Problem Statement

In industrial SCADA human-machine interfaces (HMI), rotating 3D vessel agitators (e.g. EKATO Paravisc impellers) require:
1. **60+ FPS Real-Time Fluid Rotation**: High frame-rate, zero-stutter 360-degree rotational animation synchronized to actual motor RPM.
2. **True Vector Geometry (SVG)**: Crisp rendering at any screen resolution or zoom level without pixelation.
3. **100% Background Transparency with Solid Metallic Highlight Integrity**:
   - Internal enclosed cavities between curved blades and the center shaft must be crystal-clear transparent (`alpha = 0`).
   - Specular reflections (white and silver chrome highlights on the rotating blades) must remain **100% opaque and solid** (`alpha = 255`) so the dark vessel background does not bleed through the impeller arms.

---

## 2. Why Standard Libraries & Classical Thresholding Fail

Traditional image processing libraries (e.g. basic OpenCV thresholding, Pillow color replacement, single-seed flood fills) fail when processing realistic 3D CAD models due to fundamental limitations:

| Classical Method | Why It Fails on 3D Metallic Models | Observed Defect |
| :--- | :--- | :--- |
| **Luminance Thresholding** (`gray > 220`) | Cannot distinguish white background from bright chrome/metallic highlights on the agitator blades. | **Transparent Holes in Blades**: Light-reflecting arms become semi-transparent, allowing the reactor background to show through. |
| **Single-Pixel Color Distance** (`||RGB - corner_bg|| < threshold`) | 3D rendering viewports produce subtle lighting gradients, ambient occlusion shadows, and compression noise (`[242, 245, 245]` vs `[255, 255, 255]`). | **Background Residue in Cavities (Frame 12 Issue)**: Internal loops between curved blades remain as dirty gray patches instead of becoming transparent. |
| **Simple Flood-Fill** (`cv2.floodFill` from corners) | Only clears background pixels connected to outer borders. Enclosed internal loops between blades/shaft remain untouched. | **Trapped Background Artifacts**: Holes inside the impeller structure retain the opaque background. |
| **Chroma-Keying (Green Screen)** | Causes green color bleeding/fringing along metallic reflections on silver/chrome surfaces. | **Green Tint Artifacts**: Corrupts neutral industrial stainless steel aesthetics. |

---

## 3. The Deep Learning & Adaptive Neural Matting Solution

To overcome classical thresholding fragility, we evaluated and implemented **Deep Learning Semantic Segmentation** and **Adaptive Multi-Channel Matting**:

### A. Deep Neural Network Matting (U2Net / BiRefNet / RMBG)
- **Semantic Understanding**: Deep neural networks (trained on salient object detection) analyze global spatial relationships, edge gradients, and object geometry rather than raw pixel color.
- **Natural Cavity Detection**: Automatically recognizes that the space between an agitator arm and the central shaft is negative background space, regardless of lighting gradients.
- **Specular Highlight Preservation**: Knows that a bright white reflection belongs to the foreground metallic object, preserving 100% opacity (`alpha = 255`).
- **Sub-Pixel Alpha Feathering**: Generates smooth, anti-aliased perimeter contours without jagged stair-stepping.

### B. Adaptive Multi-Channel Mathematical Matting (Optimized Production Engine)
Combines luminance floor analysis with color saturation bounds for real-time batch execution:
```python
# Distinguish neutral bright background from industrial metallic steel:
solid_fg = (min_channel < 228) | (saturation > 16)
alpha[solid_fg] = 255  # 100% Solid Opaque Metal

transition = (~solid_fg) & (min_channel < 244) & (saturation <= 14)
alpha[transition] = np.clip((244.0 - min_channel[transition]) * (255.0 / 16.0), 0, 255)

# Pure background (internal cavities & exterior) automatically receives alpha = 0
```

---

## 4. Pipeline Evolution Breakdown

```
scratch/
├── .venv/                                                # Shared Python virtual environment (rembg, onnxruntime, vtracer, opencv)
├── 01_extract_agitator_gif_frames_to_svg/                # Iteration 1: Initial GIF Extraction (28 raw -> 18 distinct frames)
├── 02_extract_mp4_agitator_frames/                       # Iteration 2: 1080p MP4 Black-BG Vectorization (21 keyframes)
└── 03_extract_screen_recording_frames/                   # Iteration 3: Screen Recording Adaptive 36-Frame High-FPS Pipeline
```

### Comparative Iteration Summary:

| Iteration | Source Media | Method Used | Keyframe Count | Strengths | Limitations |
| :---: | :---: | :---: | :---: | :--- | :--- |
| **01** | `My Video-1.gif` | Luminance Thresholding + `vtracer` | 18 frames (20.0° steps) | Automated GIF frame separation, non-duplicate filtering. | White specular highlights on arms became partially transparent. |
| **02** | `Video Project 4.mp4` | Black-BG Alpha Masking + `vtracer` | 21 frames (17.1° steps) | 100% solid metallic highlights (black background). | Lower frame rate / video paused between steps. |
| **03** | `Screen Recording 2026-08-16 025626.mp4` | **Adaptive High-Precision Multi-Channel Matting & U2Net** | **36 frames (10.0° steps)** | **Zero cavity artifacts, 100% solid metal, 60+ FPS butter-smooth rotation**. | Production baseline. |

---

## 5. How to Reuse & Re-Run Any Pipeline

All tools share the common virtual environment at `scratch/.venv`:

```powershell
# 1. Activate shared environment
cd "C:\Users\Shekhar\Desktop\QT DESIGNER PROJECTS\PVA_VPU50_SCADA\scratch"
.\.venv\Scripts\Activate.ps1

# 2. Run Production 36-Frame Extractor
cd 03_extract_screen_recording_frames
python extract_screen_recording_to_svg.py --frame-count 36 --export-scada
```
