# File Backup System

An automated backup solution for files with scheduling capabilities.

## Features

- Full backups (complete file copy)
- Partial backups (using rsync for updates)
- Compression backup (using tar with gzip)
- Scheduled backup operations (daily, weekly, or monthly)
- Operation logging to backup_file.log

## Usage

```bash
backup_file.sh <option> <file>

Options:
  --full              Perform a full backup
  --partial           Perform a partial backup using rsync
  --compress          Create a compressed backup using tar/gzip
  --schedule          Schedule automated backups
```

## Examples

```bash
# Create full backup
./backup_file.sh --full /path/to/file

# Create partial backup
./backup_file.sh --partial /path/to/file

# Create compressed backup
./backup_file.sh --compress /path/to/file

# Schedule automated backup
./backup_file.sh --schedule /path/to/file
# You will be prompted for:
# - Time (HH:MM in 24-hour format)
# - Frequency (daily|weekly|monthly)
# - Backup mode (full|partial|compress)
```

## Testing
- All test documents are in the test_documents directory
- Screenshots of test results are in the test_results directory


## Backup Details

- Full backups create a new directory named `full_backup_YYYYMMDD_HHMMSS`
- Partial backups create a new directory named `partial_backup_YYYYMMDD_HHMMSS`
- Compressed backups create a new directory named `compress_backup_YYYYMMDD_HHMMSS`
- All backups are stored in the user's home directory
- Operations are logged to backup_file.log

## Schedule Options

- Daily: Runs every day at specified time
- Weekly: Runs every Sunday at specified time
- Monthly: Runs on the 1st of each month at specified time