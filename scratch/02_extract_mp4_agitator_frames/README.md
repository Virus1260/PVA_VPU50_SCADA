# 02 - High-Definition Agitator MP4 Extraction & Vectorization Pipeline

This second iteration resolved the specular highlight transparency issue by utilizing a source video with a solid black background (`Video Project 4.mp4`), enabling clean separation of white/silver metallic reflections without color contamination.

---

## Technical Context & Method

- **Input Media**: `C:\Users\Shekhar\Videos\Video Project 4.mp4` (1080p, 1920x1080, 213 frames, 30.0 FPS)
- **Black-Background Advantage**:
  - The solid black background `[0, 0, 0]` allowed background pixels to be identified purely by low luminance (`max(R, G, B) < 15`).
  - Because metallic highlights are white/silver (`max(R, G, B) > 150`), **100% of specular reflections remained completely solid and opaque (`alpha = 255`)**.
- **Keyframe Extraction**: Scanned 213 frames and extracted **21 strictly distinct angular keyframes** spanning the 360° rotation with 17.1° steps.
- **Vector Engine**: `vtracer` generating smooth vector SVGs.

---

## Limitations of this Source Video

- **Stepped Video Animation**: The video animation contained pauses/holds between rotational steps, limiting the number of naturally smooth continuous frames to 21 distinct keyframes.
- **Frame Rate**: At 21 frames per revolution, very high RPM visualization required higher frame density for fluid animation.

---

## Execution Guide

```powershell
# 1. Activate shared environment
..\.venv\Scripts\Activate.ps1

# 2. Run extractor
python extract_mp4_frames_to_svg.py --export-scada
```
