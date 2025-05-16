# Bulk File Renamer

A utility for batch renaming files using various patterns and rules.

## Features

- Add prefixes and suffixes to filenames
- Include sequential numbering starting from a specified value
- Add datestamps (YYYYMMDD format) to filenames
- Preserves original file extensions
- Comprehensive logging to bulk_renamer.log
- Error handling for invalid directories
- Safety checks for directory permissions

## Usage

```bash
./bulk_renamer.sh [options] <directory>

Options:
  -p, --prefix <prefix>   Add a prefix to filenames
  -s, --suffix <suffix>   Add a suffix to filenames
  -c, --counter <start>   Add sequential numbers starting from <start>
  -d, --date             Add current date (YYYYMMDD) to filenames
  -h, --help             Show help message
```

## Testing
- All test documents are in the test_documents directory
- Screenshots of test results are in the test_results directory

## Requirements

- Bash shell
- Write permissions in the target directory
- Read permissions in the target directory

## Error Handling

The script checks for:
- Empty directory paths
- Non-existent directories
- Empty directories
- Read/Write permissions

All operations are logged to bulk_renamer.log for tracking and debugging.