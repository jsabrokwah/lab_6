# File Management Project

A collection of shell script utilities for file management tasks. This project includes tools for:

- Automatic file sorting
- Bulk file renaming
- Disk space analysis
- Duplicate file finding
- File backup system
- File encryption
- File synchronization

## Project Structure

- [automatic_file_sorter/](automatic_file_sorter/) - Organizes files by type
- [bulk_file_renamer/](bulk_file_renamer/) - Batch rename files using patterns
- [disk_space_analyzer/](disk_space_analyzer/) - Analyzes disk space usage
- [duplicate_file_finder/](duplicate_file_finder/) - Finds and manages duplicate files
- [file_backup_system/](file_backup_system/) - Handles file backups
- [file_encryption_tool/](file_encryption_tool/) - Encrypts/decrypts files
- [file_sync_utility/](file_sync_utility/) - Synchronizes directories

## Requirements

- Bash shell
- OpenSSL (for encryption)
- rsync (for sync utility)
- Standard Unix tools (find, du, etc.)

## Installation

Clone this repository and ensure the scripts are executable:

```bash
chmod +x */*.sh