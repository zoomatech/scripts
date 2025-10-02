#!/bin/bash
# Rename anything (file or folder) by stripping everything after ".1080p."
# Keeps file extension if present. Avoids overwriting with counter.

for target in "$@"; do
  find "$target" -depth | while read -r path; do
    dir=$(dirname "$path")
    base=$(basename "$path")

    # Match with or without extension
    if [[ "$base" =~ ^(.*1080p)\..+(\.[^.]+)$ ]]; then
      stem="${BASH_REMATCH[1]}"
      ext="${BASH_REMATCH[2]}"
      new="$stem$ext"
    elif [[ "$base" =~ ^(.*1080p)\..+$ ]]; then
      new="${BASH_REMATCH[1]}"
    else
      continue
    fi

    # Prevent overwrite by appending counter
    counter=1
    while [[ -e "$dir/$new" && "$new" != "$base" ]]; do
      new="${BASH_REMATCH[1]}_$counter${ext:-}"
      ((counter++))
    done

    if [[ "$base" != "$new" ]]; then
      mv -- "$dir/$base" "$dir/$new"
      echo "Renamed: $base -> $new"
    fi
  done
done
