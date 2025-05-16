# Disk Space Analyzer

A tool that provides detailed analysis of disk space usage in a directory structure.

## Features

- Creates tree-like visualization of directory sizes
- Sorts directories by size (ascending or descending)
- Filters results by minimum size
- Generates detailed logging
- Human-readable size formatting (B, K, M, G)

## Usage

```bash
disk_analyzer.sh <directory> [options]

Options:
  -s, --sort <asc|desc>     Sort by size (default: desc)
  -m, --min-size <bytes>    Show only items larger than size in bytes
  --max-depth <n>          Set maximum depth for analysis (default: 99)
  --help                   Show help message
```

## Examples

```bash
# Basic usage
./disk_analyzer.sh /path/to/directory

# Sort files/folders in ascending order
./disk_analyzer.sh /home/user --sort asc

# Show only files/folders larger than 1000000 bytes
./disk_analyzer.sh /var/log --min-size 1000000

# Limit directory traversal depth
./disk_analyzer.sh /usr/local --max-depth 2
```

## Output

The script creates a tree-like structure showing file and directory sizes in human-readable format (B, K, M, G). Results are logged to `disk_analyzer.log`.