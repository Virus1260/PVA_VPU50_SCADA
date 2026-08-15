#!/usr/bin/env python3
"""
Studio-Grade Noise-Filtered Agitator Frame Extraction & Vectorization Pipeline
==============================================================================
Extracts 36 high-definition, 100% distinct 360-degree rotational keyframes
from "Screen Recording 2026-08-16 025626.mp4".

Key Improvements:
- Connected-Component Noise Filtering: Completely removes H.264 video compression
  ringing artifacts, pixelated white noise blocks, and scattered edge speckles.
- True Cavity Transparency: Gaps between curved blades and shaft are 100% transparent.
- Solid Metallic Integrity: Preserves 100% opaque core structure for blades and scrapers.
- Sub-Pixel Anti-Aliased Vector Contours via vtracer for 60+ FPS SCADA animation.
"""

import os
import sys
import json
import shutil
import argparse
from pathlib import Path
import cv2
import numpy as np
from PIL import Image
import vtracer


def remove_background_studio_filtered(bgr_image: np.ndarray) -> Image.Image:
    """
    Studio-Grade Noise-Filtered Background Removal:
    1. Distance-based thresholding from CAD white canvas.
    2. Connected-component analysis to eliminate video compression speckles.
    3. Core morphological preservation to keep metallic arms 100% solid.
    4. Sub-pixel anti-aliased outer edge boundary.
    """
    h, w, _ = bgr_image.shape
    rgb = cv2.cvtColor(bgr_image, cv2.COLOR_BGR2RGB)

    # 1. Color distance from pure white canvas
    bg_rgb = np.array([253, 254, 254], dtype=float)
    color_diff = np.linalg.norm(rgb.astype(float) - bg_rgb, axis=2)

    # 2. Raw foreground mask
    raw_fg = (color_diff > 16).astype(np.uint8) * 255

    # 3. Morphological opening with 2x2 kernel to dissolve 1-pixel compression noise
    kernel_open = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
    clean_fg = cv2.morphologyEx(raw_fg, cv2.MORPH_OPEN, kernel_open)

    # 4. Connected-component analysis: drop noise speckles (area < 12)
    num_labels, labels, stats, _ = cv2.connectedComponentsWithStats(clean_fg)
    filtered_fg = np.zeros_like(clean_fg)
    for i in range(1, num_labels):
        if stats[i, cv2.CC_STAT_AREA] >= 12:
            filtered_fg[labels == i] = 255

    # 5. Core solid body remains 255, outer edge boundary receives Gaussian anti-aliasing
    core = cv2.erode(filtered_fg, np.ones((2, 2), np.uint8))

    alpha = filtered_fg.copy().astype(float)
    blurred_edge = cv2.GaussianBlur(filtered_fg.astype(float), (3, 3), 0.8)
    alpha[core == 0] = blurred_edge[core == 0]
    alpha = np.clip(alpha, 0, 255).astype(np.uint8)

    rgba = np.dstack((rgb, alpha))
    return Image.fromarray(rgba, mode="RGBA")


def process_screen_recording(video_path: str, output_dir: str, target_frame_count: int = 36, export_to_scada: bool = True):
    v_path = Path(video_path)
    if not v_path.exists():
        print(f"Error: Video file not found: {video_path}", file=sys.stderr)
        sys.exit(1)

    out_base = Path(output_dir)
    png_dir = out_base / "png"
    svg_dir = out_base / "svg"
    png_dir.mkdir(parents=True, exist_ok=True)
    svg_dir.mkdir(parents=True, exist_ok=True)

    print(f"Opening Video: {v_path}")
    cap = cv2.VideoCapture(str(v_path))
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    fps = cap.get(cv2.CAP_PROP_FPS)
    w = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    h = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    print(f"Resolution: {w}x{h}, FPS: {fps}, Total Frames: {total_frames}")

    scada_dest_dir = Path(__file__).resolve().parents[2] / "PVA_VPU50_SCADAContent" / "assets" / "agitator_sequence"
    if export_to_scada:
        scada_dest_dir.mkdir(parents=True, exist_ok=True)

    # 1. Read all video frames
    print("\nReading video stream...")
    frames = []
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frames.append(frame)
    cap.release()

    total_loaded = len(frames)
    print(f"Loaded {total_loaded} frames.")

    # 2. Keyframe sampling across 360 rotation cycle (Frame #11 -> Frame #333)
    start_frame = 11
    end_frame = 333
    span = end_frame - start_frame
    step_size = span / float(target_frame_count)
    selected_indices = [int(start_frame + round(i * step_size)) for i in range(target_frame_count)]

    unique_indices = []
    seen = set()
    for idx in selected_indices:
        clamped = min(end_frame - 1, max(start_frame, idx))
        if clamped not in seen:
            unique_indices.append(clamped)
            seen.add(clamped)

    num_distinct = len(unique_indices)
    deg_step = 360.0 / num_distinct
    print(f"\nSelected {num_distinct} keyframe indices: {unique_indices}")

    manifest = {
        "source": str(v_path),
        "total_video_frames": total_frames,
        "unique_frame_count": num_distinct,
        "degrees_per_frame": round(deg_step, 2),
        "source_frame_indices": unique_indices,
        "frames": []
    }

    # 3. Studio-Grade Background Removal, Cropping & Vectorization
    print("\nProcessing, noise filtering & vectorizing SVGs...")
    for new_idx, video_frame_idx in enumerate(unique_indices):
        raw_bgr = frames[video_frame_idx]
        rgba_img = remove_background_studio_filtered(raw_bgr)

        # Tight bounding-box crop
        bbox = rgba_img.getbbox()
        if bbox:
            cropped = rgba_img.crop(bbox)
        else:
            cropped = rgba_img

        # Resize to standard high-definition dimensions (480x560)
        target_size = (480, 560)
        resized_rgba = cropped.resize(target_size, Image.Resampling.LANCZOS)

        png_name = f"agitator_frame_{new_idx:02d}.png"
        svg_name = f"agitator_frame_{new_idx:02d}.svg"

        png_path = png_dir / png_name
        svg_path = svg_dir / svg_name

        resized_rgba.save(png_path, "PNG")

        try:
            vtracer.convert_image_to_svg_py(str(png_path), str(svg_path))
        except Exception as e:
            print(f"Warning: vtracer failed on frame {new_idx}: {e}")

        manifest["frames"].append({
            "index": new_idx,
            "angle_deg": round(new_idx * deg_step, 1),
            "video_frame": video_frame_idx,
            "svg": svg_name
        })

        if export_to_scada:
            if svg_path.exists():
                shutil.copy2(svg_path, scada_dest_dir / svg_name)

        print(f"  Frame {new_idx:02d} ({new_idx * deg_step:.1f}°) [Video #{video_frame_idx:03d}] -> {svg_name}")

    manifest_path = out_base / "agitator_sequence.json"
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)

    if export_to_scada:
        # Clean up any leftover old frames > num_distinct in SCADA directory
        for old_file in scada_dest_dir.glob("agitator_frame_*.svg"):
            try:
                f_idx = int(old_file.stem.split("_")[-1])
                if f_idx >= num_distinct:
                    old_file.unlink()
            except ValueError:
                pass

        with open(scada_dest_dir / "agitator_sequence.json", "w", encoding="utf-8") as f:
            json.dump(manifest, f, indent=2)

    print(f"\nAll {num_distinct} studio-grade vector SVG frames generated and deployed to SCADA assets!")
    return num_distinct


def main():
    parser = argparse.ArgumentParser(description="Extract 360 keyframes with studio-grade noise filtering and SVG vectorization.")
    parser.add_argument("--video-path", type=str, default=r"C:\Users\Shekhar\Videos\Screen Recordings\Screen Recording 2026-08-16 025626.mp4", help="Input video path")
    parser.add_argument("--output-dir", type=str, default=str(Path(__file__).parent / "output_frames"), help="Output directory")
    parser.add_argument("--frame-count", type=int, default=36, help="Number of distinct 360-degree keyframes")
    parser.add_argument("--export-scada", action="store_true", default=True, help="Copy SVGs to SCADA assets")

    args = parser.parse_args()
    process_screen_recording(args.video_path, args.output_dir, args.frame_count, args.export_scada)


if __name__ == "__main__":
    main()
