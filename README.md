# Bash Video Processing Toolkit

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://opensource.org/licenses/GPL-2.0)

A collection of robust Bash utilities designed for automated video transcoding and lossless concatenation. This project provides a reliable workflow for compressing high-resolution source files using H.265 (HEVC) and merging them into a single distribution-ready container.

## Key Highlights
* **Automated Transcoding Pipeline**: Implements a H.265/HEVC encoding workflow using `libx265` with specific CRF and preset configurations.
* **Defensive Shell Scripting**: Utilizes `set -euo pipefail` for immediate error termination and `trap` for automated temporary file cleanup.
* **Lossless Stream Concatenation**: Employs FFmpeg's `concat` demuxer to merge processed clips without re-encoding, preserving generational quality.
* **Resilient File Handling**: Includes logic for skipping already-processed files, handling interrupted sessions via partial-file detection, and shell globbing safety with `nullglob`.

## Features
* **Batch Compression**: Automatically discovers and processes `.mp4` and `.mov` files.
* **State Management**: Detects `-p.mp4` (partial) and `-c.mp4` (complete) suffixes to prevent redundant processing.
* **Standardized Audio**: Normalizes audio streams to AAC at 128k during the compression phase.
* **Stream Optimization**: Applies `+faststart` flags to output containers for improved web streaming playback.

## Tech Stack
* **Language**: Bash (Unix Shell)
* **Core Tool**: FFmpeg
* **Video Codec**: H.265/HEVC (`libx265`)
* **Audio Codec**: AAC

## Project Structure
* `compress.sh`: Handles batch transcoding of source files into a normalized format.
* `combine.sh`: Aggregates all processed clips into a single output file using a generated file list.
* [cite_start]`LICENSE`: Project governed by the GNU General Public License v2[cite: 1, 19].

## Installation
Ensure you have FFmpeg installed on a Unix-like environment (Linux, macOS, or WSL).

1. Clone the repository or download the script files.
2. Grant execution permissions to the scripts:
```bash
chmod +x compress.sh combine.sh
```

## Usage

### 1. Compress Videos
Run the compression script in a directory containing `.mp4` or `.mov` files. This will generate `-c.mp4` versions of your media.
```bash
./compress.sh
```

### 2. Combine Videos
After compression, merge the resulting `-c.mp4` files into a single video. You can optionally provide a name for the output file.
```bash
./combine.sh final_output.mp4
```
*Note: If no argument is provided, the script defaults to `combined_video.mp4`.*

## License
[cite_start]This project is licensed under the **GNU General Public License v2**[cite: 1]. [cite_start]You are free to distribute and modify this software under the terms of the license, provided that recipients receive the same rights and source code access[cite: 7, 10, 11].