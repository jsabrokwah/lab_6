#!/usr/bin/bash

# This script is a program that backs up important files to another place.
# Include options for full and partial backups, compression, and scheduling.
# File copying, date/time handling, scheduling, compression methods

# Usage: ./backup_file.sh [--full|--partial|--compress|--schedule] path/to/file
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 [--full|--partial|--compress|--schedule] path/to/file"
    exit 1
fi

# Check if the file exists
if [ ! -f "$2" ]; then
    echo "File $2 does not exist."
    exit 1
fi
# Check if the file is readable
if [ ! -r "$2" ]; then
    echo "File $2 is not readable."
    exit 1
fi

# Handle errors
set -euo pipeline

# Configure logging
log_file="duplicate_finder.log"
exec 3>&1 1>>${log_file} 2>&1


write_log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >&3
}

# Function to perform a full backup
full_backup() {
    local file="$1"
    local backup_dir="full_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "/home/$USER/$backup_dir"
    cp "$file" "/home/$USER/$backup_dir/"
    echo "Full backup of $file completed in $backup_dir"
    write_log "Full backup of $file completed in $backup_dir"
}

# Function to perform a partial backup
partial_backup() {
    local file="$1"
    local backup_dir="partial_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "/home/$USER/$backup_dir"
    rsync -av --update "$file" "/home/$USER/$backup_dir/"
    echo "Partial backup of $file completed in $backup_dir"
    write_log "Partial backup of $file completed in $backup_dir"
}

# Function to compress backup files
compress_backup() {
    local file="$1"
    local backup_dir="compress_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "/home/$USER/$backup_dir"
    tar -czf "/home/$USER/$backup_dir/backup.tar.gz" "$file"
    echo "Compression of $file completed in $backup_dir"
    write_log "Compression of $file completed in $backup_dir"
}

# Function to schedule backups for daily, weekly, or monthly at at the user's specified time
# Function to schedule backups for daily, weekly, or monthly at at the user's specified time
schedule_backup() {
    local time="$1"
    local frequency="$2"
    local mode="$3"
    local cron_job=""
    local hour="${time%%:*}"
    local minute="${time##*:}"

    case "$frequency" in
        daily)
            cron_job="$minute $hour * * * $(pwd)/backup_file.sh --$mode $2"
            ;;
        weekly)
            cron_job="$minute $hour * * 0 $(pwd)/backup_file.sh --$mode $2"
            ;;
        monthly)
            cron_job="$minute $hour 1 * * $(pwd)/backup_file.sh --$mode $2"
            ;;
        *)
            echo "Invalid frequency. Use daily, weekly, or monthly."
            exit 1
            ;;
    esac

    # Validate time format
    if ! [[ $hour =~ ^[0-9]{1,2}$ ]] || ! [[ $minute =~ ^[0-9]{1,2}$ ]] || 
       [ "$hour" -gt 23 ] || [ "$minute" -gt 59 ]; then
        echo "Invalid time format. Please use HH:MM (24-hour format)"
        exit 1
    fi

    (crontab -l 2>/dev/null || true; echo "$cron_job") | crontab -
    echo "Backup scheduled: $cron_job"
    write_log "Backup scheduled: $cron_job"
}

if [ "$1" == "--full" ]; then
    full_backup "$2"
elif [ "$1" == "--partial" ]; then
    partial_backup "$2"
elif [ "$1" == "--compress" ]; then
    compress_backup "$2"
elif [ "$1" == "--schedule" ]; then
    # Prompt user for time, frequency, and mode
    echo -e "You need to provide the time, frequency, and mode for scheduling.\n NB: This script will automatically run at the specified time, frequency, and mode.\n"
    read -p "Enter the time (HH:MM) for scheduling backup: " time
    read -p "Enter the frequency (daily|weekly|monthly): " frequency
    read -p "Enter backup mode (full|partial|compress): " mode
    schedule_backup "$time" "$frequency" "$mode"
else
    echo "Invalid option"
    exit 1
fi
