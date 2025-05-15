#!/usr/bin/bash

# This script is a tool to show which folders and files use the most space.
# It creates a tree-like structure to display disk usage and offer options to sort and filter results.
# It makes use of Recursion, data sorting, output formatting, data visualization
# and error handling.

set -euo pipefail

# Print help message
if [[ "${1:-}" == "--help" ]]; then
    echo "Usage: $0 <directory> [--sort asc|desc] [--min-size <size>] [--max-depth <depth>]"
    exit 0
fi

# Check correct usage
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <directory> [--sort asc|desc] [--min-size <size>] [--max-depth <depth>]"
    exit 1
fi

# Check if the provided argument is a directory
DIR="$1"
if [ ! -d "$DIR" ]; then
    echo "Error: $DIR is not a directory."
    exit 1
fi

# Check if the directory is readable
if [ ! -r "$DIR" ]; then
    echo "Error: $DIR is not readable."
    exit 1
fi

# Set default values
SORT="desc"
MIN_SIZE=0
MAX_DEPTH=99

# Shift to process optional flags
shift

# Parse optional arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -s|--sort) SORT="$2"; shift ;;
        -m|--min-size) MIN_SIZE="$2"; shift ;;
        --max-depth) MAX_DEPTH="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Configure logging
log_file="disk_analyzer.log"
exec 3>&1 1>>${log_file} 2>&1

write_log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >&3
}

# Human-readable size formatter
human_readable() {
    local SIZE=$1
    if [ "$SIZE" -lt 1024 ]; then
        echo "${SIZE}B"
    elif [ "$SIZE" -lt $((1024 * 1024)) ]; then
        echo "$((SIZE / 1024))K"
    elif [ "$SIZE" -lt $((1024 * 1024 * 1024)) ]; then
        echo "$((SIZE / 1024 / 1024))M"
    else
        echo "$((SIZE / 1024 / 1024 / 1024))G"
    fi
}

# Recursive function
disk_usage() {
    local PATH=$1
    local INDENT=$2
    local CUR_DEPTH=$3

    if [ "$CUR_DEPTH" -gt "$MAX_DEPTH" ]; then
        return
    fi

    local ENTRIES=()
    local IFS=$'\n'

    for ENTRY in "$PATH"/*; do
        if [ -e "$ENTRY" ]; then
            local SIZE=$(du -sb "$ENTRY" 2>/dev/null | cut -f1)
            if [ "$SIZE" -ge "$MIN_SIZE" ]; then
                ENTRIES+=("$SIZE|$ENTRY")
            fi
        fi
    done

    if [ "$SORT" == "asc" ]; then
        ENTRIES=($(printf "%s\n" "${ENTRIES[@]}" | sort -n))
    else
        ENTRIES=($(printf "%s\n" "${ENTRIES[@]}" | sort -nr))
    fi

    for ITEM in "${ENTRIES[@]}"; do
        local SIZE=$(echo "$ITEM" | cut -d'|' -f1)
        local FILE=$(echo "$ITEM" | cut -d'|' -f2)
        local BASENAME=$(basename "$FILE")
        local SIZE_HR=$(human_readable "$SIZE")

        printf "%s├── %s (%s)\n" "$INDENT" "$BASENAME" "$SIZE_HR"

        if [ -d "$FILE" ]; then
            disk_usage "$FILE" "$INDENT    " $((CUR_DEPTH + 1))
        fi
    done
}

# Start analysis
write_log "Starting disk usage analysis for: $DIR"
echo "Disk Usage Tree for: $DIR"
disk_usage "$DIR" "" 1
write_log "Completed disk usage analysis for: $DIR"
