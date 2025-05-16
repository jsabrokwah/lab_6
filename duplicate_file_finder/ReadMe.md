# Duplicate File Finder

A utility to identify and manage duplicate files using MD5 hash comparison.

## Features

- Duplicate detection using MD5 hashing
- Interactive file management (delete/move options)
- Detailed logging of all operations
- Safe operation with user confirmation
- Support for single directory scanning

## Usage

```bash
duplicate_finder.sh <directory>
```

The script will:
1. Scan the specified directory for duplicate files
2. For each duplicate found, prompt user to:
   - Delete the file (d)
   - Move the file to another location (m)
   - Skip the file (any other key)

## Examples

```bash
# Basic usage
./duplicate_finder.sh ~/Pictures

# The script will interactively prompt for actions on each duplicate found
```

## Output

- Results are displayed in the terminal
- All operations are logged to `duplicate_finder.log`