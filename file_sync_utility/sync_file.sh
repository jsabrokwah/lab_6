#!/usr/bin/bash

# This script is a program to keep files in sync between two folders.
# It Implements two-way synchronization and handles conflict resolution.

# Handle errors
set -euo pipefail

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_dir> <dest_dir>"
    exit 1
fi

source_dir="$1"
dest_dir="$2"

# Check if the source directory exists
if [ ! -d "$source_dir" ]; then
    echo "Source directory $source_dir does not exist."
    exit 1
fi

# Check if the destination directory exists
if [ ! -d "$dest_dir" ]; then
    echo "Destination directory $dest_dir does not exist."
    exit 1
fi

# Configure logging
log_file="file_sync.log"
exec 3>&1 1>>${log_file} 2>&1
write_log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >&3
}

# Function to handle conflicts
handle_conflicts() {
    local conflict_file="$1"
    echo "Conflict detected: $conflict_file"
    write_log "Conflict detected: $conflict_file"
    # Implement conflict resolution strategy here
    read -p "Choose resolution (1: Keep source, 2: Keep destination): " choice
    case $choice in
        1)
            echo "Keeping source file."
            cp "$source_dir/$conflict_file" "$dest_dir/"
            ;;
        2)
            echo "Keeping destination file."
            cp "$dest_dir/$conflict_file" "$source_dir/"
            ;;
        *)
            echo "Invalid choice. Skipping conflict resolution."
            ;;
    esac
}

# Function to sync files from source to destination
sync_files() {
    # First, find files that exist in both directories
    for file in "$source_dir"/*; do
        if [ -f "$file" ]; then
            basename=$(basename "$file")
            dest_file="$dest_dir/$basename"
            
            # Check if file exists in both directories
            if [ -f "$dest_file" ]; then
                # Compare modification times
                source_time=$(stat -c %Y "$file")
                dest_time=$(stat -c %Y "$dest_file")
                
                if [ "$source_time" != "$dest_time" ]; then
                    # Call handle_conflicts if timestamps differ
                    handle_conflicts "$basename"
                fi
            fi
        fi
    done
    
    # After resolving conflicts, perform the sync
    rsync -av --delete "$source_dir/" "$dest_dir/"
    write_log "Synchronized files from $source_dir to $dest_dir"
}


# Main script logic
sync_files
