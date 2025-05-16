#!/usr/bin/bash

# This script finds and list duplicate files in a folder.
# It uses file size and content comparison to spot duplicates and offer choices to delete or move them.
# It make use of File comparison, hashing, arrays, user interaction


# Check if the directory path is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

# Check if the provided path is a directory
if [ ! -d "$1" ]; then
    echo "Directory $1 does not exist."
    write_log "Directory $1 does not exist."
    exit 1
fi
#Check if the provided directory is empty
if [ -z "$(ls -A "$1")" ]; then
    echo "Directory $1 is empty."
    write_log "Directory $1 is empty."
    exit 0
fi

# Handle errors
set -euo pipefail

# Configure logging
log_file="duplicate_finder.log"
exec  2>>${log_file} 2>&1


write_log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" 
}

# Set the directory to be scanned
DIRECTORY="$1"

# Function to delete duplicate files
delete_duplicate(){
    local file="$1"
    echo "Deleting duplicate file: $file"
    rm -f "$file"
    write_log "Deleted duplicate file: $file"
}

# Function to move duplicate files
move_duplicate(){
    local file="$1"
    local target_dir="$2"
    echo "Moving duplicate file: $file to $target_dir"
    mv "$file" "$target_dir"
    write_log "Moved duplicate file: $file to $target_dir"
}


# Function to find duplicate files
find_duplicates(){
    local dir="$1"
    declare -A file_hashes    # Declare associative array
    local duplicates=()

    # Loop through files in the directory
    for file in "$dir"/*; do
        if [ -f "$file" ]; then
            # Calculate the hash of the file
            local hash=$(md5sum "$file" | cut -d ' ' -f 1)
            # Check if the hash already exists
            if [[ -n "${file_hashes[$hash]:-}" ]]; then    # Add default empty value
                duplicates+=("$file")
                duplicates+=("${file_hashes[$hash]}")
            else
                file_hashes[$hash]="$file"
            fi
        fi
    done

    # Print duplicates
    if [ ${#duplicates[@]} -gt 0 ]; then
        echo "Duplicate files found:"
        for dup in "${duplicates[@]}"; do
            echo "$dup"
            # Offer choices to delete or move the duplicate file
            read -p "Delete or move duplicate file $dup? (d/m) " choice
            case "$choice" in
                d)
                    delete_duplicate "$dup"
                    ;;
                m)
                    read -p "Enter target directory for moving $dup: " target_dir
                    move_duplicate "$dup" "$target_dir"
                    ;;
                *)
                    echo "Invalid choice. Skipping $dup."
                    ;;
            esac
        done
    else
        echo "No duplicate files found."
    fi
}

find_duplicates "$DIRECTORY"
write_log "Duplicate file search completed in directory: $DIRECTORY"
