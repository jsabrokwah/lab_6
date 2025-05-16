# Automatic File Sorter

A Bash script that automatically organizes files into categorized directories based on their file extensions.

## Features

- Automatically sorts files into predefined categories:
  - Documents (.doc, .docx, .pdf)
  - Images (.jpg, .jpeg, .png, .gif)
  - Videos (.mp4, .mkv, .avi)
  - Other (all other file types)
- Handles files with spaces in names safely
- Maintains a detailed log file (file_sorter.log) with timestamps
- Preserves original file names
- Includes error handling and input validation
- Creates category directories automatically as needed

## Usage

```bash
./file_sorter.sh <directory_path>
```

### Example
```bash
./file_sorter.sh ~/Downloads
```

## Requirements

- Bash shell
- Write permissions in the target directory
- Execute permissions for the script (`chmod +x file_sorter.sh`)

## Notes

- The script will not process subdirectories
- Empty directories will be reported in the log
- Existing files with the same name in destination folders will be overwritten