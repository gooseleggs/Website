from pathlib import Path
import sys
import hashlib
import os
import re

ASSET_EXTS = {'.avif', '.js', '.css', '.woff2'}
SEARCH_EXTS = {'.html', '.js', '.css'}
HASH_LEN = 8

def compute_hash(path: Path, block_size: int = 65536) -> str:
    """Return SHA256 hex digest of path"""
    h = hashlib.sha256()
    with path.open('rb') as f:
        for chunk in iter(lambda: f.read(block_size), b''):
            h.update(chunk)
    return h.hexdigest()[:HASH_LEN]

def build_asset_map(root: Path):
    """Return dict {old_rel_path: new_rel_path}, renaming files on disk."""
    mapping = {}
    for path in root.rglob('*'):
        if path.is_file() and path.suffix.lower() in ASSET_EXTS:

            rel = path.relative_to(root)
            digest = compute_hash(path)

            new_name = f"{path.stem}.{digest}{path.suffix}"
            new_path = path.with_name(new_name)

            os.rename(path, new_path)

            old_path = str(rel).replace('\\', '/')
            new_path = str(new_path.relative_to(root)).replace('\\', '/')

            mapping[old_path] = new_path

    return mapping

def update_references(root: Path, mapping: dict):
    """Replace occurrences of each *old* path with *new* path within SEARCH_EXTS files."""
    if not mapping:
        return
    # Build one big regex from all keys, longest first to avoid substr collisions
    escaped = sorted((re.escape(k) for k in mapping.keys()), key=len, reverse=True)
    pattern = re.compile('|'.join(escaped))

    for path in root.rglob('*'):
        if path.is_file() and path.suffix.lower() in SEARCH_EXTS:
            text = path.read_text(encoding='utf-8', errors='ignore')

            new_text = pattern.sub(lambda x: mapping[x.group(0)], text)

            if new_text != text:
                path.write_text(new_text, encoding='utf-8')

def main():
    html_root = '/app/out'

    root = Path(html_root).resolve()

    if not root.is_dir():
        sys.exit(f"{root} is not a directory")

    mapping = build_asset_map(root)
    update_references(root, mapping)

    print("Cache busting complete. Renamed files:")
    for old, new in mapping.items():
        print(f"  {old} → {new}")

if __name__ == '__main__':
    main()
