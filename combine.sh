#!/usr/bin/env bash

shopt -s nullglob nocaseglob

list_file='files.txt'
final_output=${1:-combined_video.mp4}

files=(*-c.mp4)

if (( ${#files[@]} == 0 )); then
    printf 'Error: No normalized files (*-c.mp4) found.\n' >&2
    exit 1
fi

if ! : > "$list_file"; then
    printf 'Error: Cannot write "%s".\n' "$list_file" >&2
    exit 2
fi

count=0

for f in "${files[@]}"; do
    if ! printf "file '%s'\n" "$f" >> "$list_file"; then
        printf 'Error: Failed writing "%s".\n' "$list_file" >&2
        exit 3
    fi

    ((count++))
done

printf 'Concatenating %d clips into %s...\n' "$count" "$final_output"

ffmpeg \
    -hide_banner \
    -loglevel error \
    -stats \
    -f concat \
    -safe 0 \
    -i "$list_file" \
    -c copy \
    "$final_output"

ffmpeg_status=$?

if (( ffmpeg_status != 0 )); then
    printf 'Error: Concatenation failed.\n' >&2
    exit 4
fi

if ! rm -f -- "$list_file"; then
    printf 'Warning: Failed to remove "%s".\n' "$list_file" >&2
fi

printf 'Success: %s created.\n' "$final_output"