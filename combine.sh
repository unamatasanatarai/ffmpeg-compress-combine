#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob nocaseglob

readonly LIST_FILE="files.txt"
readonly FINAL_OUTPUT="${1:-combined_video.mp4}"

trap 'rm -f "$LIST_FILE"' EXIT

: > "$LIST_FILE"

for f in *-c.mp4; do
    printf "file '%s'\n" "$f" >> "$LIST_FILE"
done

if [[ ! -s "$LIST_FILE" ]]; then
    echo "Error: No normalized files (*-c.mp4) found." >&2
    exit 1
fi

mapfile -t count < "$LIST_FILE"
echo "Concatenating ${#count[@]} clips into $FINAL_OUTPUT..."

if ! ffmpeg -hide_banner -loglevel error -stats \
    -f concat -safe 0 -i "$LIST_FILE" \
    -c copy \
    "$FINAL_OUTPUT"; then
    echo "Error: Concatenation failed!" >&2
    exit 1
fi

echo "Success: $FINAL_OUTPUT created."
