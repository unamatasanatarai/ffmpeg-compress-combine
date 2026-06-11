#!/usr/bin/env bash

dir=${1-.}

mapfile -t files < <(
    find "$dir" \( -iname '*.mov' -o -iname '*.mp4' \) -type f
)

if (( $? != 0 )); then
    printf 'find failed\n' >&2
    exit 1
fi

for f in "${files[@]}"; do
    w=$(mdls -raw -name kMDItemPixelWidth "$f")
    h=$(mdls -raw -name kMDItemPixelHeight "$f")

    if [[ $w =~ ^[0-9]+$ && $h =~ ^[0-9]+$ ]] && (( h > w )); then
        printf '%s\n' "$f"
    fi
done
