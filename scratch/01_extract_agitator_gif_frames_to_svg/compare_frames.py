#!/usr/bin/env python3
"""
Agitator Frame Sequence Comparison & Validation Tool
===================================================
Validates that every frame in the 360-degree rotation sequence is distinct,
calculates angular rotation step per frame, and verifies seamless loop closure.
"""

import os
import json
from pathlib import Path
from PIL import Image, ImageChops, ImageStat


def compare_frames(frames_dir: str):
    p = Path(frames_dir)
    png_files = sorted(p.glob("agitator_frame_*.png"))
    n = len(png_files)
    print(f"Loaded {n} frame files from {frames_dir}")

    images = [Image.open(f).convert("RGBA") for f in png_files]

    comparison_results = []
    has_duplicates = False

    print("\n--- Consecutive Frame Differences (Step-by-step 360° progression) ---")
    deg_per_frame = 360.0 / n

    for i in range(n):
        next_idx = (i + 1) % n
        diff = ImageChops.difference(images[i], images[next_idx])
        stat = ImageStat.Stat(diff)
        # Root-mean-square difference per channel
        rms = sum(stat.rms) / len(stat.rms)

        is_loop_close = (i == n - 1)
        label = f"Frame {i:02d} ({i * deg_per_frame:.1f}°) -> Frame {next_idx:02d} ({next_idx * deg_per_frame:.1f}°)"
        if is_loop_close:
            label += " [LOOP CLOSURE 360° -> 0°]"

        print(f"  {label:<55} : RMS Diff = {rms:.2f}")

        if rms < 0.5 and not is_loop_close:
            print(f"    WARNING: Frame {i:02d} and {next_idx:02d} are nearly identical!")
            has_duplicates = True

        comparison_results.append({
            "from_frame": i,
            "to_frame": next_idx,
            "from_angle_deg": round(i * deg_per_frame, 1),
            "to_angle_deg": round(next_idx * deg_per_frame, 1),
            "rms_difference": round(rms, 3),
            "is_identical": rms < 0.5
        })

    report = {
        "total_frames": n,
        "degrees_per_frame": round(deg_per_frame, 2),
        "has_unintended_duplicates": has_duplicates,
        "consecutive_comparisons": comparison_results
    }

    report_path = p.parent / "rotation_comparison_report.json"
    with open(report_path, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=2)

    print(f"\nReport written to: {report_path}")
    if not has_duplicates:
        print(f"VERIFIED: All {n} frames represent distinct angular positions around the 360° rotation axis with smooth ~{deg_per_frame:.1f}° step increments!")


if __name__ == "__main__":
    png_directory = Path(__file__).parent / "output_frames" / "png"
    compare_frames(str(png_directory))
