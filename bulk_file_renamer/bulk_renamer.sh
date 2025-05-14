#!/usr/bin/bash

# This script is a tool that renames many files using patterns or rules.
# The user specifies naming conventions, adds prefixes or suffixes, and uses counters or dates in filenames.
# It makes use loops, regular expressions, command-line inputs, string formatting

# usage function
usage() {
    echo "Usage: $0 [options] <directory>"
    echo "Options:"
    echo "  -p, --prefix <prefix>   Add a prefix to the filenames"
    echo "  -s, --suffix <suffix>   Add a suffix to the filenames"
    echo "  -c, --counter <start>   Start a counter from <start>"
    echo "  -d, --date             Add the current date to the filenames"
    echo "  -h, --help             Show this help message"
}


# The script is designed to be user-friendly and flexible, allowing for various renaming options.
# Check if the user has provided a directory
if [ $# -eq 0 ]; then
    echo "No directory provided."
    usage
    exit 1
fi

# Handle errors
set -euo pipefail

# Configure logging
log_file="bulk_renamer.log"
exec 3>&1 1>>${log_file} 2>&1

write_log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >&3
}

# Initialize variables
prefix=""
suffix=""
counter=0
date_flag=false
directory=""
# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--prefix)
            prefix="$2"
            shift 2
            ;;
        -s|--suffix)
            suffix="$2"
            shift 2
            ;;
        -c|--counter)
            counter="$2"
            shift 2
            ;;
        -d|--date)
            date_flag=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            directory="$1"
            shift
            ;;
    esac
done

# Log the parsed arguments and options
write_log "Parsed arguments: prefix='$prefix', suffix='$suffix', counter='$counter', date_flag='$date_flag', directory='$directory'"
# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Directory $directory does not exist."
    write_log "Directory $directory does not exist."
    exit 1
fi
# Check if the directory is empty
if [ -z "$(ls -A "$directory")" ]; then
    echo "Directory $directory is empty."
    write_log "Directory $directory is empty."
    exit 1
fi
# Check if the directory is writable
if [ ! -w "$directory" ]; then
    echo "Directory $directory is not writable."
    write_log "Directory $directory is not writable."
    exit 1
fi
# Check if the directory is readable
if [ ! -r "$directory" ]; then
    echo "Directory $directory is not readable."
    write_log "Directory $directory is not readable."
    exit 1
fi


bulk_rename() {
    write_log "Starting bulk rename in directory: $directory"
    # Loop through all files in the directory
    for file in "$directory"/*; do
        # Check if it's a file
        if [ -f "$file" ]; then
            # Get the file name and extension
            filename=$(basename "$file")
            extension="${filename##*.}"
            filename="${filename%.*}"
            # Add prefix and suffix
            new_filename="${prefix}${filename}${suffix}"
            # Add counter if specified
            if [ $counter -gt 0 ]; then
                new_filename="${new_filename}_$counter"
                ((counter++))
            fi
            # Add date if specified
            if [ "$date_flag" = true ]; then
                new_filename="${new_filename}_$(date +%Y%m%d)"
            fi
            # Rename the file
            mv "$file" "$directory/$new_filename.$extension"
        fi
        write_log "Renamed $file to $directory/$new_filename.$extension"
    done
}

# Call the bulk_rename function
bulk_rename
