#!/usr/bin/env python3
"""
High-Definition Agitator MP4 Extraction & Vectorization Pipeline
================================================================
Extracts all distinct 360-degree rotational frames from "Video Project 4.mp4".
Preserves 100% of solid metallic highlights (white/silver arms) while setting
the black background to transparent with anti-aliasing.
Vectorizes each frame into crisp, clean SVG for high-FPS SCADA animation.
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

try:
    import vtracer
except ImportError:
    vtracer = None


def make_black_bg_transparent(bgr_image: np.ndarray) -> Image.Image:
    """
    Converts solid black background [0, 0, 0] to transparent.
    Leaves all white/silver metallic highlights 100% solid and opaque.
    """
    rgb = cv2.cvtColor(bgr_image, cv2.COLOR_BGR2RGB)
    h, w, _ = rgb.shape

    # Calculate max brightness per pixel across R, G, B
    max_channel = np.max(rgb, axis=2)

    # Compute Alpha channel:
    # 0 for pure black (<= 6), ramp 7..20, 255 for >= 20
    alpha = np.zeros((h, w), dtype=np.uint8)
    opaque_mask = max_channel >= 20
    alpha[opaque_mask] = 255

    feather_mask = (max_channel > 6) & (max_channel < 20)
    alpha[feather_mask] = ((max_channel[feather_mask] - 6) * (255.0 / 14.0)).astype(np.uint8)

    rgba = np.dstack((rgb, alpha))
    return Image.fromarray(rgba, mode="RGBA")


def process_video(video_path: str, output_dir: str, export_to_scada: bool = True):
    v_path = Path(video_path)
    if not v_path.exists():
        print(f"Error: Video file not found: {video_path}", file=sys.stderr)
        sys.exit(1)

    out_base = Path(output_dir)
    png_dir = out_base / "png"
    svg_dir = out_base / "svg"
    png_dir.mkdir(parents=True, exist_ok=True)
    svg_dir.mkdir(parents=True, exist_ok=True)

    print(f"Opening MP4 Video: {v_path}")
    cap = cv2.VideoCapture(str(v_path))
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    fps = cap.get(cv2.CAP_PROP_FPS)
    w = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    h = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    print(f"Resolution: {w}x{h}, FPS: {fps}, Total Frames: {total_frames}")

    scada_dest_dir = Path(__file__).resolve().parents[2] / "PVA_VPU50_SCADAContent" / "assets" / "agitator_sequence"
    if export_to_scada:
        scada_dest_dir.mkdir(parents=True, exist_ok=True)

    # 1. Read all frames and identify unique rotational keyframes
    print("\nScanning video for distinct rotational keyframes...")
    raw_frames = []
    unique_indices = []
    prev_thumb = None

    frame_idx = 0
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # Crop to agitator center bounding box (X: 490..1430, Y: 0..1080)
        crop = frame[:, 490:1430]
        raw_frames.append(crop)

        # Thumbnail for fast motion diffing
        thumb = cv2.resize(crop, (94, 108))

        if prev_thumb is None:
            unique_indices.append(frame_idx)
            prev_thumb = thumb
        else:
            diff = np.mean(np.abs(thumb.astype(float) - prev_thumb.astype(float)))
            if diff > 8.0:  # distinct rotation threshold
                unique_indices.append(frame_idx)
                prev_thumb = thumb

        frame_idx += 1

    cap.release()

    # Filter loop closure (remove frame if near-identical to frame 0)
    final_indices = [unique_indices[0]]
    first_thumb = cv2.resize(raw_frames[0], (94, 108))

    for u_idx in unique_indices[1:]:
        curr_thumb = cv2.resize(raw_frames[u_idx], (94, 108))
        diff_first = np.mean(np.abs(curr_thumb.astype(float) - first_thumb.astype(float)))
        if diff_first > 6.0:  # not yet looped back to start
            final_indices.append(u_idx)

    num_distinct = len(final_indices)
    print(f"\nExtracted {num_distinct} 100% distinct rotational frames across 360°:")
    print(f"Keyframe indices: {final_indices}")

    deg_step = 360.0 / num_distinct

    manifest = {
        "source": str(v_path),
        "total_video_frames": total_frames,
        "unique_frame_count": num_distinct,
        "degrees_per_frame": round(deg_step, 2),
        "source_frame_indices": final_indices,
        "frames": []
    }

    # 2. Convert and Vectorize each distinct frame
    print("\nVectorizing distinct frames into high-definition SVGs...")
    for new_idx, raw_idx in enumerate(final_indices):
        bgr_crop = raw_frames[raw_idx]
        rgba_img = make_black_bg_transparent(bgr_crop)

        # Resize to standard crisp dimensions (500x574)
        target_size = (500, int(500 * (1080.0 / 940.0)))
        resized_rgba = rgba_img.resize(target_size, Image.Resampling.LANCZOS)

        png_name = f"agitator_frame_{new_idx:02d}.png"
        svg_name = f"agitator_frame_{new_idx:02d}.svg"

        png_path = png_dir / png_name
        svg_path = svg_dir / svg_name

        resized_rgba.save(png_path, "PNG")

        if vtracer is not None:
            try:
                vtracer.convert_image_to_svg_py(str(png_path), str(svg_path))
            except Exception as e:
                print(f"Warning: vtracer failed on frame {new_idx}: {e}")

        manifest["frames"].append({
            "index": new_idx,
            "angle_deg": round(new_idx * deg_step, 1),
            "video_frame": raw_idx,
            "svg": svg_name
        })

        if export_to_scada:
            if svg_path.exists():
                shutil.copy2(svg_path, scada_dest_dir / svg_name)

        print(f"  Frame {new_idx:02d} ({new_idx * deg_step:.1f}°) [Video #{raw_idx:03d}] -> {svg_name}")

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

    print(f"\nAll {num_distinct} high-definition vector SVG frames generated and deployed to SCADA assets!")
    return num_distinct


def main():
    parser = argparse.ArgumentParser(description="Extract HD distinct frames from MP4 and vectorize to SVG for SCADA.")
    parser.add_argument("--video-path", type=str, default=r"C:\Users\Shekhar\Videos\Video Project 4.mp4", help="Input MP4 path")
    parser.add_argument("--output-dir", type=str, default=str(Path(__file__).parent / "output_frames"), help="Output directory")
    parser.add_argument("--export-scada", action="store_true", default=True, help="Copy to SCADA Content assets")

    args = parser.parse_args()
    process_video(args.video_path, args.output_dir, args.export_scada)


if __name__ == "__main__":
    main()
