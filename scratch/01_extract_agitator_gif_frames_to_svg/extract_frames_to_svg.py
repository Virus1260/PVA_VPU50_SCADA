#!/usr/bin/env python3
"""
Agitator GIF Frame Extraction & SVG Vectorization Script
========================================================
Extracts frames from an animated GIF, removes background to make it transparent,
filters out duplicate/hold frames, and vectorizes every distinct rotational frame to SVG.
"""

import os
import sys
import json
import shutil
import argparse
from pathlib import Path
from PIL import Image, ImageChops, ImageStat

try:
    import vtracer
except ImportError:
    vtracer = None


def make_transparent(image: Image.Image) -> Image.Image:
    """Converts near-white / off-white background to transparent."""
    img = image.convert("RGBA")
    w, h = img.size
    pixels = img.load()

    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if (r > 215 and g > 215 and b > 195) or (r > 240 and g > 240 and b > 240):
                pixels[x, y] = (0, 0, 0, 0)
            elif r > 200 and g > 200 and b > 190:
                lum = min(r, g, b)
                alpha = int(255 * (1.0 - (lum - 200) / 40.0))
                pixels[x, y] = (r, g, b, max(0, min(255, alpha)))

    return img


def process_gif(gif_path: str, output_dir: str, export_to_scada: bool = True):
    gif_file = Path(gif_path)
    if not gif_file.exists():
        print(f"Error: GIF file not found at {gif_path}", file=sys.stderr)
        sys.exit(1)

    out_base = Path(output_dir)
    raw_png_dir = out_base / "raw_png"
    distinct_png_dir = out_base / "png"
    distinct_svg_dir = out_base / "svg"

    raw_png_dir.mkdir(parents=True, exist_ok=True)
    distinct_png_dir.mkdir(parents=True, exist_ok=True)
    distinct_svg_dir.mkdir(parents=True, exist_ok=True)

    print(f"Opening GIF: {gif_file}")
    im = Image.open(gif_file)
    n_frames = getattr(im, "n_frames", 1)
    print(f"Detected {n_frames} raw frames. Size: {im.size}")

    scada_dest_dir = Path(__file__).resolve().parents[2] / "PVA_VPU50_SCADAContent" / "assets" / "agitator_sequence"
    if export_to_scada:
        scada_dest_dir.mkdir(parents=True, exist_ok=True)

    raw_images = []
    for idx in range(n_frames):
        im.seek(idx)
        t_frame = make_transparent(im)
        raw_images.append(t_frame)
        t_frame.save(raw_png_dir / f"raw_frame_{idx:02d}.png", "PNG")

    # Filter strictly unique rotational frames across 360 degrees
    unique_indices = [0]
    for i in range(1, n_frames):
        prev_idx = unique_indices[-1]
        diff_prev = ImageChops.difference(raw_images[prev_idx], raw_images[i])
        rms_prev = sum(ImageStat.Stat(diff_prev).rms) / len(ImageStat.Stat(diff_prev).rms)

        diff_0 = ImageChops.difference(raw_images[0], raw_images[i])
        rms_0 = sum(ImageStat.Stat(diff_0).rms) / len(ImageStat.Stat(diff_0).rms)

        if rms_prev > 15.0 and rms_0 > 10.0:
            unique_indices.append(i)

    print(f"\nExtracted {len(unique_indices)} 100% distinct rotational frames across 360°:")
    print(f"Indices: {unique_indices}")

    manifest = {
        "source": str(gif_file),
        "total_raw_frames": n_frames,
        "unique_frame_count": len(unique_indices),
        "source_indices": unique_indices,
        "frames": []
    }

    deg_step = 360.0 / len(unique_indices)

    for new_idx, orig_idx in enumerate(unique_indices):
        frame_img = raw_images[orig_idx]
        png_name = f"agitator_frame_{new_idx:02d}.png"
        svg_name = f"agitator_frame_{new_idx:02d}.svg"

        png_path = distinct_png_dir / png_name
        svg_path = distinct_svg_dir / svg_name

        frame_img.save(png_path, "PNG")

        if vtracer is not None:
            try:
                vtracer.convert_image_to_svg_py(str(png_path), str(svg_path))
            except Exception as e:
                print(f"Warning: vtracer failed on frame {new_idx}: {e}")

        manifest["frames"].append({
            "sequence_index": new_idx,
            "original_gif_frame": orig_idx,
            "angle_deg": round(new_idx * deg_step, 1),
            "png": png_name,
            "svg": svg_name
        })

        if export_to_scada:
            shutil.copy2(png_path, scada_dest_dir / png_name)
            if svg_path.exists():
                shutil.copy2(svg_path, scada_dest_dir / svg_name)

        print(f"  Frame {new_idx:02d} ({new_idx * deg_step:.1f}°) [Raw #{orig_idx:02d}] -> {svg_name}")

    manifest_path = out_base / "agitator_sequence.json"
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)

    if export_to_scada:
        with open(scada_dest_dir / "agitator_sequence.json", "w", encoding="utf-8") as f:
            json.dump(manifest, f, indent=2)

    print(f"\nAll {len(unique_indices)} unique SVG frames generated and deployed to SCADA assets!")


def main():
    parser = argparse.ArgumentParser(description="Extract distinct GIF frames and vectorize to SVG for SCADA.")
    parser.add_argument("--gif-path", type=str, default=r"C:\Users\Shekhar\Videos\My Video-1.gif", help="Path to input GIF")
    parser.add_argument("--output-dir", type=str, default=str(Path(__file__).parent / "output_frames"), help="Output directory")
    parser.add_argument("--export-scada", action="store_true", default=True, help="Copy to SCADA Content assets directory")

    args = parser.parse_args()
    process_gif(args.gif_path, args.output_dir, args.export_scada)


if __name__ == "__main__":
    main()
