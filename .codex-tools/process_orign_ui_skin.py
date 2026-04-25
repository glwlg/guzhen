from pathlib import Path

import numpy as np
from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "assets" / "orign"

SPECS = {
    "panel_dark_gold_9slice.png": ("ui/skin", (512, 512), "checker"),
    "panel_inner_9slice.png": ("ui/skin", (512, 512), "checker"),
    "header_plate_9slice.png": ("ui/skin", (640, 96), "checker"),
    "button_default_9slice.png": ("ui/skin", (512, 160), "checker"),
    "button_hover_9slice.png": ("ui/skin", (512, 160), "checker"),
    "button_active_9slice.png": ("ui/skin", (512, 160), "checker"),
    "button_danger_9slice.png": ("ui/skin", (512, 160), "checker"),
    "resource_card_9slice.png": ("ui/skin", (420, 150), "checker"),
    "lifespan_bar_frame.png": ("ui/skin", (900, 140), "checker"),
    "nav_tab_9slice.png": ("ui/skin", (420, 120), "checker"),
    "ornament_corner_gold.png": ("ui/skin", (128, 128), "checker"),
    "divider_gold.png": ("ui/skin", (512, 16), "checker"),
    "noise_scratches_overlay.png": ("ui/skin", (1024, 1024), "overlay"),
    "matrix_bg.png": ("ui/killer", (1200, 900), "dark"),
    "matrix_core_slot_frame.png": ("ui/killer", (360, 360), "checker"),
    "matrix_plugin_slot_frame.png": ("ui/killer", (260, 260), "checker"),
}


def remove_checker_background(image: Image.Image) -> Image.Image:
    rgb = image.convert("RGB")
    pixels = np.array(rgb, dtype=np.uint8)
    max_channel = pixels.max(axis=2)
    min_channel = pixels.min(axis=2)
    chroma = max_channel - min_channel

    # Source images contain a baked light gray/white transparency checkerboard.
    background = (min_channel > 205) & (chroma < 36)
    alpha = np.full(background.shape, 255, dtype=np.uint8)
    alpha[background] = 0

    rgba = np.dstack((pixels, alpha))
    return Image.fromarray(rgba, "RGBA")


def crop_to_visible(image: Image.Image) -> Image.Image:
    alpha = image.getchannel("A")
    bbox = alpha.getbbox()
    if bbox is None:
        return image
    return image.crop(bbox)


def make_overlay(image: Image.Image) -> Image.Image:
    rgb = image.convert("RGB")
    pixels = np.array(rgb, dtype=np.float32)
    luma = (
        pixels[:, :, 0] * 0.2126
        + pixels[:, :, 1] * 0.7152
        + pixels[:, :, 2] * 0.0722
    )
    alpha = np.clip((luma - 9.0) * 3.3, 0, 110).astype(np.uint8)
    color = np.empty((*alpha.shape, 3), dtype=np.uint8)
    color[:, :, 0] = 174
    color[:, :, 1] = 148
    color[:, :, 2] = 96
    return Image.fromarray(np.dstack((color, alpha)), "RGBA")


def process_one(filename: str, output_subdir: str, size: tuple[int, int], mode: str) -> None:
    source = SOURCE_DIR / filename
    if not source.exists():
        print(f"SKIP {source.relative_to(ROOT)}")
        return

    if mode == "overlay":
        image = make_overlay(Image.open(source))
    elif mode == "dark":
        image = Image.open(source).convert("RGBA")
    else:
        image = crop_to_visible(remove_checker_background(Image.open(source)))
    image = image.resize(size, Image.Resampling.LANCZOS)

    output_dir = ROOT / "assets" / output_subdir
    output_dir.mkdir(parents=True, exist_ok=True)
    output = output_dir / filename
    image.save(output)
    print(f"OK {source.relative_to(ROOT)} -> {output.relative_to(ROOT)} {size[0]}x{size[1]}")


def main() -> int:
    for filename, (output_subdir, size, mode) in SPECS.items():
        process_one(filename, output_subdir, size, mode)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
