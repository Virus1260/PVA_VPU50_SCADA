#!/usr/bin/env python3
"""
GrabCut Energy-Minimization Agitator Frame Extraction & Vectorization Pipeline
==============================================================================
Extracts 36 strictly distinct 360-degree rotational keyframes from
"Screen Recording 2026-08-16 032628.mp4" (No-Reflection Mode).

Folder Structure:
- 01_raw_video_frames/        : Exact raw extracted video frames from recording.
- 02_transparent_bg_frames/   : GrabCut background-removed transparent PNGs.
- 03_vector_svg_frames/       : Clean vector SVGs generated via vtracer.
- agitator_sequence.json      : Full animation sequence manifest.
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


def remove_background_grabcut(bgr_image: np.ndarray) -> Image.Image:
    """
    GrabCut Graph-Cut Energy Minimization Background Removal:
    Iteratively segments foreground metallic structures from the ambient canvas.
    """
    h, w, _ = bgr_image.shape
    mask = np.zeros((h, w), np.uint8)
    bgdModel = np.zeros((1, 65), np.float64)
    fgdModel = np.zeros((1, 65), np.float64)

    # Initialize GrabCut with bounding rectangle
    rect = (6, 6, w - 12, h - 12)
    cv2.grabCut(bgr_image, mask, rect, bgdModel, fgdModel, 5, cv2.GC_INIT_WITH_RECT)

    # Pure white / light ambient background pixels are classified as background
    gray = cv2.cvtColor(bgr_image, cv2.COLOR_BGR2GRAY)
    hsv = cv2.cvtColor(bgr_image, cv2.COLOR_BGR2HSV)
    sat = hsv[:, :, 1]

    # Combine GrabCut classification with high-luminance check
    is_definite_bg = (mask == cv2.GC_BGD) | (mask == cv2.GC_PR_BGD) | ((gray > 222) & (sat < 15))
    is_fg = (~is_definite_bg).astype(np.uint8) * 255

    # Connected-component cleanup to drop isolated 1-pixel noise
    num_labels, labels, stats, _ = cv2.connectedComponentsWithStats(is_fg)
    filtered_fg = np.zeros_like(is_fg)
    for i in range(1, num_labels):
        if stats[i, cv2.CC_STAT_AREA] >= 10:
            filtered_fg[labels == i] = 255

    # Core solid retention and smooth Gaussian perimeter edge
    core = cv2.erode(filtered_fg, np.ones((2, 2), np.uint8))
    blurred_edge = cv2.GaussianBlur(filtered_fg.astype(float), (3, 3), 0.8)

    alpha = filtered_fg.copy().astype(float)
    alpha[core == 0] = blurred_edge[core == 0]
    alpha = np.clip(alpha, 0, 255).astype(np.uint8)

    rgb = cv2.cvtColor(bgr_image, cv2.COLOR_BGR2RGB)
    rgba = np.dstack((rgb, alpha))
    return Image.fromarray(rgba, mode="RGBA")


def process_pipeline(video_path: str, output_base_dir: str, target_frame_count: int = 36, export_to_scada: bool = True):
    v_path = Path(video_path)
    if not v_path.exists():
        print(f"Error: Video file not found: {video_path}", file=sys.stderr)
        sys.exit(1)

    base_dir = Path(output_base_dir)
    raw_dir = base_dir / "01_raw_video_frames"
    trans_dir = base_dir / "02_transparent_bg_frames"
    svg_dir = base_dir / "03_vector_svg_frames"

    raw_dir.mkdir(parents=True, exist_ok=True)
    trans_dir.mkdir(parents=True, exist_ok=True)
    svg_dir.mkdir(parents=True, exist_ok=True)

    print(f"Opening Source Video: {v_path}")
    cap = cv2.VideoCapture(str(v_path))
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    fps = cap.get(cv2.CAP_PROP_FPS)
    w = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    h = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    print(f"Resolution: {w}x{h}, FPS: {fps}, Total Video Frames: {total_frames}")

    scada_dest_dir = Path(__file__).resolve().parents[2] / "PVA_VPU50_SCADAContent" / "assets" / "agitator_sequence"
    if export_to_scada:
        scada_dest_dir.mkdir(parents=True, exist_ok=True)

    # 1. Read all video frames
    print("\nReading video frames into memory...")
    frames = []
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frames.append(frame)
    cap.release()

    total_loaded = len(frames)
    print(f"Loaded {total_loaded} frames.")

    # 2. Keyframe sampling across 360 rotation cycle (Frame #2 -> Frame #301)
    start_frame = 2
    end_frame = 301
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
    print(f"\nSelected {num_distinct} distinct rotational keyframes across 360° ({deg_step:.1f}° per step):")
    print(f"Video Frame Indices: {unique_indices}")

    manifest = {
        "source": str(v_path),
        "segmentation_algorithm": "GrabCut Energy Minimization",
        "total_video_frames": total_frames,
        "unique_frame_count": num_distinct,
        "degrees_per_frame": round(deg_step, 2),
        "source_frame_indices": unique_indices,
        "frames": []
    }

    # 3. Process Stages (01_raw -> 02_transparent -> 03_svg)
    print("\nProcessing 3-stage pipeline...")
    for new_idx, video_frame_idx in enumerate(unique_indices):
        raw_bgr = frames[video_frame_idx]
        
        # --- STAGE 1: Save Raw Frame ---
        raw_frame_name = f"raw_frame_{new_idx:02d}.png"
        raw_path = raw_dir / raw_frame_name
        cv2.imwrite(str(raw_path), raw_bgr)

        # --- STAGE 2: GrabCut Background Removal & Cropping ---
        rgba_img = remove_background_grabcut(raw_bgr)
        bbox = rgba_img.getbbox()
        if bbox:
            cropped = rgba_img.crop(bbox)
        else:
            cropped = rgba_img

        target_size = (480, 560)
        resized_rgba = cropped.resize(target_size, Image.Resampling.LANCZOS)

        trans_png_name = f"agitator_frame_{new_idx:02d}.png"
        trans_path = trans_dir / trans_png_name
        resized_rgba.save(trans_path, "PNG")

        # --- STAGE 3: SVG Vectorization via vtracer ---
        svg_name = f"agitator_frame_{new_idx:02d}.svg"
        svg_path = svg_dir / svg_name

        try:
            vtracer.convert_image_to_svg_py(str(trans_path), str(svg_path))
        except Exception as e:
            print(f"Warning: vtracer failed on frame {new_idx}: {e}")

        manifest["frames"].append({
            "index": new_idx,
            "angle_deg": round(new_idx * deg_step, 1),
            "video_frame": video_frame_idx,
            "raw_frame": raw_frame_name,
            "transparent_png": trans_png_name,
            "svg": svg_name
        })

        if export_to_scada:
            if svg_path.exists():
                shutil.copy2(svg_path, scada_dest_dir / svg_name)

        print(f"  [{new_idx:02d}/{num_distinct-1:02d}] {new_idx * deg_step:5.1f}° (Video #{video_frame_idx:03d}) -> Raw: {raw_frame_name} | PNG: {trans_png_name} | SVG: {svg_name}")

    manifest_path = base_dir / "agitator_sequence.json"
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

    print(f"\nAll {num_distinct} keyframes successfully processed across the 3 separate directories and deployed to SCADA assets!")
    return num_distinct


def main():
    parser = argparse.ArgumentParser(description="Extract 360 keyframes with GrabCut energy minimization into separate raw/png/svg folders.")
    parser.add_argument("--video-path", type=str, default=r"C:\Users\Shekhar\Videos\Screen Recordings\Screen Recording 2026-08-16 032628.mp4", help="Input video path")
    parser.add_argument("--output-dir", type=str, default=str(Path(__file__).parent), help="Output base directory")
    parser.add_argument("--frame-count", type=int, default=36, help="Number of distinct 360-degree keyframes")
    parser.add_argument("--export-scada", action="store_true", default=True, help="Copy SVGs to SCADA assets")

    args = parser.parse_args()
    process_pipeline(args.video_path, args.output_dir, args.frame_count, args.export_scada)


if __name__ == "__main__":
    main()
