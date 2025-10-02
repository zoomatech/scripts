#!/bin/bash
# Rename anything (file or folder) by stripping everything after ".1080p."
# Keeps file extension if present. Avoids overwriting with counter.

# Script: strip_to1080p.sh
# Purpose: Recursively rename files and folders by stripping everything
#          after ".1080p." while preserving file extensions.
# Features:
#   - Dry run mode (--dry-run) shows changes without renaming
#   - Duplicate protection: appends _1, _2, etc. to avoid overwriting
# Usage:
#   ./strip_to1080p.sh [--dry-run] <folder1> <folder2> ...
#
# Example:
#   ./strip_to1080p.sh --dry-run test
#   ./strip_to1080p.sh test
dryrun="false"
if [[ "$1" == "--dry-run" ]]; then
  dryrun="true"
  shift
fi

for target in "$@"; do
  # -depth ensures children get renamed before parent directories
  find "$target" -depth | while read -r path; do
    dir=$(dirname "$path")
    base=$(basename "$path")

    # Case 1: filename with extension
    if [[ "$base" =~ ^(.*1080p)\..+(\.[^.]+)$ ]]; then
      stem="${BASH_REMATCH[1]}"
      ext="${BASH_REMATCH[2]}"
      new="$stem$ext"

    # Case 2: directory name (no extension)
    elif [[ "$base" =~ ^(.*1080p)\..+$ ]]; then
      stem="${BASH_REMATCH[1]}"
      ext=""
      new="$stem"
    else
      continue
    fi

    # Avoid overwriting: add counter if target exists
    counter=1
    while [[ -e "$dir/$new" && "$new" != "$base" ]]; do
      new="${stem}_$counter${ext}"
      ((counter++))
    done

    # Perform action
    if [[ "$base" != "$new" ]]; then
      if [[ "$dryrun" == "true" ]]; then
        echo "Would rename: $base -> $new"
      else
        mv -- "$dir/$base" "$dir/$new"
        echo "Renamed: $base -> $new"
      fi
    fi
  done
done
