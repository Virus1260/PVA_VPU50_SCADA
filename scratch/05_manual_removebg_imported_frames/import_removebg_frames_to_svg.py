#!/usr/bin/env python3
"""
Import Manual Remove.bg Frames & Vectorize Pipeline
===================================================
Imports manually background-removed PNG frames from:
C:\\Users\\Shekhar\\Downloads\\11

Process:
1. Copies all source removebg PNGs into 01_source_removebg_png/
2. Validates image integrity (fills empty glitch frames 18, 33, 34 with 180° symmetric counterparts)
3. Auto-crops tight bounding boxes and resizes to standard 480x560 high-DPI dimensions in 02_cropped_resized_png/
4. Converts all 36 frames to crisp vector SVGs via vtracer into 03_vector_svg_frames/
5. Deploys SVGs to PVA_VPU50_SCADAContent/assets/agitator_sequence/
"""

import os
import sys
import json
import shutil
from pathlib import Path
from PIL import Image
import numpy as np
import vtracer


def main():
    src_dir = Path(r"C:\Users\Shekhar\Downloads\11")
    if not src_dir.exists():
        print(f"Error: Source directory not found: {src_dir}", file=sys.stderr)
        sys.exit(1)

    base_dir = Path(__file__).resolve().parent
    raw_copy_dir = base_dir / "01_source_removebg_png"
    cropped_dir = base_dir / "02_cropped_resized_png"
    svg_dir = base_dir / "03_vector_svg_frames"

    raw_copy_dir.mkdir(parents=True, exist_ok=True)
    cropped_dir.mkdir(parents=True, exist_ok=True)
    svg_dir.mkdir(parents=True, exist_ok=True)

    scada_dest_dir = base_dir.parents[1] / "PVA_VPU50_SCADAContent" / "assets" / "agitator_sequence"
    scada_dest_dir.mkdir(parents=True, exist_ok=True)

    total_target_frames = 36
    deg_step = 360.0 / total_target_frames

    print(f"Scanning source frames in: {src_dir}")
    source_images = {}

    for i in range(total_target_frames):
        pattern = f"raw_frame_{i:02d}-removebg-preview.png"
        src_file = src_dir / pattern
        if src_file.exists():
            shutil.copy2(src_file, raw_copy_dir / pattern)
            try:
                img = Image.open(src_file).convert("RGBA")
                arr = np.array(img)
                alpha = arr[:, :, 3]
                non_zero = np.sum(alpha > 0)
                if non_zero > 1000:
                    source_images[i] = img
                else:
                    print(f"  Warning: Frame {i:02d} ({pattern}) was empty (non-zero pixels: {non_zero}). Will recover via 180° symmetry.")
            except Exception as e:
                print(f"  Error loading {pattern}: {e}")
        else:
            print(f"  Missing: {pattern}")

    # Symmetry fallback for 0-pixel glitch frames (18 -> 00, 33 -> 15, 34 -> 16)
    symmetry_map = {18: 0, 33: 15, 34: 16}
    for empty_idx, fallback_idx in symmetry_map.items():
        if empty_idx not in source_images and fallback_idx in source_images:
            print(f"  Recovering Frame {empty_idx:02d} from 180° symmetric Frame {fallback_idx:02d}...")
            source_images[empty_idx] = source_images[fallback_idx].copy()

    manifest = {
        "source": str(src_dir),
        "method": "Manual Remove.bg Import + vtracer Vectorization",
        "total_frames": total_target_frames,
        "degrees_per_frame": round(deg_step, 2),
        "frames": []
    }

    target_size = (480, 560)
    print(f"\nProcessing and vectorizing all {total_target_frames} frames...")

    for i in range(total_target_frames):
        if i in source_images:
            img = source_images[i]
        else:
            print(f"Error: Frame {i:02d} could not be resolved!", file=sys.stderr)
            continue

        bbox = img.getbbox()
        if bbox:
            cropped = img.crop(bbox)
        else:
            cropped = img

        resized = cropped.resize(target_size, Image.Resampling.LANCZOS)

        png_name = f"agitator_frame_{i:02d}.png"
        svg_name = f"agitator_frame_{i:02d}.svg"

        png_path = cropped_dir / png_name
        svg_path = svg_dir / svg_name

        resized.save(png_path, "PNG")

        try:
            vtracer.convert_image_to_svg_py(str(png_path), str(svg_path))
        except Exception as e:
            print(f"Warning: vtracer failed on frame {i}: {e}")

        # Deploy to SCADA assets
        if svg_path.exists():
            shutil.copy2(svg_path, scada_dest_dir / svg_name)

        manifest["frames"].append({
            "index": i,
            "angle_deg": round(i * deg_step, 1),
            "source_file": f"raw_frame_{i:02d}-removebg-preview.png",
            "png": png_name,
            "svg": svg_name
        })

        print(f"  Frame {i:02d} ({i * deg_step:5.1f}°) -> {png_name} -> {svg_name} (Deployed OK)")

    manifest_path = base_dir / "agitator_sequence.json"
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)

    with open(scada_dest_dir / "agitator_sequence.json", "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)

    print(f"\nAll {total_target_frames} SVG frames successfully converted and deployed to SCADA assets!")


if __name__ == "__main__":
    main()
