# File Sync Utility

A basic file synchronization tool that maintains consistency between directories using rsync.

## Features

- One-way synchronization with --delete option
- Basic conflict detection based on timestamps
- Interactive conflict resolution
- Operation logging to file_sync.log
- Basic error handling and validation

## Usage

```bash
sync_file.sh <source_dir> <target_dir>
```

## Examples

```bash
# Basic directory sync
./sync_file.sh ~/Projects ~/Backup/Projects
```
## Testing
- All test documents are in the source_dir directory
- The synch copy is in the destination_dir directory
- Screenshots of test results are in the test_results directory


## Conflict Resolution

The utility handles conflicts using the following strategy:
1. Timestamp comparison
2. Interactive resolution prompt (keep source or destination)
3. Final rsync sync after resolution

## Requirements

- rsync
- Standard Unix utilities (stat, cp)
- Write permissions in both directories
- Sufficient permissions to create log file