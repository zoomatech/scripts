# 1080p Renamer Script

This Bash script recursively renames files and directories by removing everything after `.1080p.` while preserving file extensions.

## Features
- **Dry-run mode**: Use the `--dry-run` flag to preview renames without making changes.
- **Duplicate protection**: If a target name already exists, the script appends `_1`, `_2`, etc. to avoid overwriting.
- Works on macOS (zsh/bash). Compatible with Linux bash as well.

## Usage

Preview changes (no renaming performed):
```bash
./strip_to1080p.sh --dry-run test
```

Perform actual renames:
```bash
./strip_to1080p.sh test
```

You can pass multiple directories at once:
```bash
./strip_to1080p.sh --dry-run folder1 folder2
```
