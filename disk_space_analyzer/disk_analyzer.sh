#!/bin/bash

# This script is a tool to show which folders and files use the most space.
# It creates a tree-like structure to display disk usage and offer options to sort and filter results.
# It makes use of Recursion, data sorting, output formatting, data visualization
# and error handling.

set -euo pipefail
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# ------------------------#
#      HELP & USAGE      #
# ------------------------#

# Print help message
if [[ "${1:-}" == "--help" ]]; then
    echo "Usage: $0 <directory> [--sort asc|desc] [--min-size <size>] [--max-depth <depth>]"
    exit 0
fi

# Ensure at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <directory> [--sort asc|desc] [--min-size <size>] [--max-depth <depth>]"
    exit 1
fi

# -----------------------------#
#   INITIAL DIRECTORY CHECKS   #
# -----------------------------#

DIR="$1"

# Check if the provided path is a directory
if [ ! -d "$DIR" ]; then
    echo "Error: $DIR is not a directory."
    exit 1
fi

# Check if the directory is readable
if [ ! -r "$DIR" ]; then
    echo "Error: $DIR is not readable."
    exit 1
fi

# -----------------------------#
#   PARSE OPTIONAL ARGUMENTS   #
# -----------------------------#

SORT="desc"         # Default sort order
MIN_SIZE=0          # Minimum file size to display
MAX_DEPTH=99        # Default maximum recursion depth
shift               # Move past the first directory argument

# Parse flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -s|--sort) SORT="$2"; shift ;;
        -m|--min-size) MIN_SIZE="$2"; shift ;;
        --max-depth) MAX_DEPTH="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# ------------------------#
#       LOGGING SETUP     #
# ------------------------#

log_file="disk_analyzer.log"

# Log only custom messages
write_log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >>"$log_file"
}

# Redirect only errors
exec 2>>"$log_file"

# ------------------------#
#   SIZE FORMATTER FUNC   #
# ------------------------#

# Convert size in bytes to human-readable format
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

# ------------------------#
#     SORT FUNCTION       #
# ------------------------#

# Sorts an array of entries (SIZE|PATH) in-place using bubble sort
sort_entries() {
    local -n arr=$1
    local N=${#arr[@]}
    for ((i = 0; i < N; i++)); do
        for ((j = 0; j < N - i - 1; j++)); do
            local a_size=${arr[j]%%|*}
            local b_size=${arr[j+1]%%|*}
            if [[ "$SORT" == "asc" && "$a_size" -gt "$b_size" ]] || \
               [[ "$SORT" == "desc" && "$a_size" -lt "$b_size" ]]; then
                # Swap
                local tmp=${arr[j]}
                arr[j]=${arr[j+1]}
                arr[j+1]=$tmp
            fi
        done
    done
}

# ------------------------#
#   DISK USAGE RECURSION  #
# ------------------------#

# Recursively traverse a directory and print size tree
disk_usage() {
    local CUR_PATH=$1
    local INDENT=$2
    local CUR_DEPTH=$3

    if [ "$CUR_DEPTH" -gt "$MAX_DEPTH" ]; then
        return
    fi

    local ENTRIES=()
    local ENTRY SIZE

    for ENTRY in "$CUR_PATH"/*; do
        if [ -e "$ENTRY" ]; then
            SIZE=$(du -sb "$ENTRY" 2>/dev/null | awk '{print $1}')
            if [[ "$SIZE" =~ ^[0-9]+$ ]] && [ "$SIZE" -ge "$MIN_SIZE" ]; then
                ENTRIES+=("$SIZE|$ENTRY")
            fi
        fi
    done

    # Sort entries before displaying
    sort_entries ENTRIES

    for ITEM in "${ENTRIES[@]}"; do
        local SIZE=${ITEM%%|*}
        local FILE=${ITEM#*|}
        local BASENAME=$(basename "$FILE")
        local SIZE_HR=$(human_readable "$SIZE")

        printf "%s├── %s (%s)\n" "$INDENT" "$BASENAME" "$SIZE_HR" 

        if [ -d "$FILE" ]; then
            disk_usage "$FILE" "$INDENT    " $((CUR_DEPTH + 1))
        fi
    done
}

# ------------------------#
#        MAIN EXEC        #
# ------------------------#

write_log "Starting disk usage analysis for: $DIR"
echo "Disk Usage Tree for: $DIR"
disk_usage "$DIR" "" 1
write_log "Completed disk usage analysis for: $DIR"
