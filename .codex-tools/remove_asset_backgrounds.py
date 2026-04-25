from pathlib import Path

from rembg import new_session, remove


ROOT = Path(__file__).resolve().parents[1]
TARGET_DIRS = (
    ROOT / "assets" / "characters",
    ROOT / "assets" / "effects",
    ROOT / "assets" / "ui",
)


def main() -> int:
    files = sorted(
        path
        for directory in TARGET_DIRS
        for path in directory.rglob("*.png")
        if path.is_file()
    )

    if not files:
        print("No PNG files found.")
        return 0

    session = new_session("u2net")
    print(f"Found {len(files)} PNG files.")

    for index, path in enumerate(files, start=1):
        relative = path.relative_to(ROOT)
        tmp_path = path.with_suffix(path.suffix + ".tmp")
        try:
            output = remove(path.read_bytes(), session=session)
            tmp_path.write_bytes(output)
            tmp_path.replace(path)
            print(f"[{index}/{len(files)}] OK {relative}")
        except Exception:
            if tmp_path.exists():
                tmp_path.unlink()
            raise

    print("Done.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
