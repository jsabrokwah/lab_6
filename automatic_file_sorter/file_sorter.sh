#!/usr/bin/bash

# This script that organizes files in a folder based on their types.
# The script scans a directory, find file extensions, and move files into suitable subfolders (e.g., Documents,Images, Videos).
# It make use of file handling, string manipulation, if-else statements, and make directory commands.

# Usage: ./file_sorter.sh <directory_path>

# Check if the directory path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi
# Check if the provided path is a directory
if [ ! -d "$1" ]; then
    echo "Error: $1 is not a valid directory."
    exit 1
fi

# Enable strict error handling
set -euo pipefail
# Set logging file
LOG_FILE="file_sorter.log"
exec > >(tee -i "$LOG_FILE")
exec 2>&1

# Set IFS to newline and tab to handle file names with spaces
IFS=$'\n\t'
# Define the directory to be sorted
DIRECTORY="$1"

write_log() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message"
}

# Sort files into subdirectories
sort_files() {
    for file in "$DIRECTORY"/*; do
        if [ -f "$file" ]; then
            local extension="${file##*.}"
            # Use case statement to determine the file type
            # and move it to the appropriate subdirectory
            case "$extension" in
                doc|docx|pdf)
                    # Create Documents directory if it doesn't exist
                    if [ ! -d "$DIRECTORY/Documents" ]; then
                        mkdir "$DIRECTORY/Documents"
                    fi
                    mv "$file" "$DIRECTORY/Documents/"
                    write_log "Moved $file to Documents"
                    ;;
                jpg|jpeg|png|gif)
                    # Create Images directory if it doesn't exist
                    if [ ! -d "$DIRECTORY/Images" ]; then
                        mkdir "$DIRECTORY/Images"
                    fi
                    mv "$file" "$DIRECTORY/Images/"
                    write_log "Moved $file to Images"
                    ;;
                mp4|mkv|avi)
                    # Create Videos directory if it doesn't exist
                    if [ ! -d "$DIRECTORY/Videos" ]; then
                        mkdir "$DIRECTORY/Videos"
                    fi          
                    mv "$file" "$DIRECTORY/Videos/"
                    write_log "Moved $file to Videos"
                    ;;
                *)
                    # Create Other directory if it doesn't exist
                    if [ ! -d "$DIRECTORY/Other" ]; then
                        mkdir "$DIRECTORY/Other"
                    fi
                    mv "$file" "$DIRECTORY/Other/"
                    write_log "Moved $file to Other"
                    ;;
            esac
        fi
    done
}


# Check if the directory is empty
if [ -z "$(ls -A "$DIRECTORY")" ]; then
    write_log "The directory is empty."
    echo "The directory is empty. No files to sort."
    exit 0
else
    write_log "Sorting files in $DIRECTORY..."
    sort_files
    write_log "File sorting completed."
    echo "File sorting completed."
fi
