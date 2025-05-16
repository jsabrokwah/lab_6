# File Encryption Tool

A secure file encryption and decryption utility using OpenSSL AES-256-CBC.

## Features

- Strong AES-256-CBC encryption
- Password-based encryption
- Operation logging to file_encryption.log
- Error handling and validation
- File permissions checking

## Usage

```bash
encrypt_file.sh <option> <password> <file>

Options:
  --encrypt       Encrypt the file (outputs to file.enc)
  --decrypt       Decrypt the file (removes .enc extension)
```

## Examples

```bash
# Encrypt a file
./encrypt_file.sh --encrypt "your_password" sensitive_data.txt

# Decrypt a file
./encrypt_file.sh --decrypt "your_password" sensitive_data.txt.enc
```

## Security Notes

- Uses OpenSSL's AES-256-CBC encryption
- Implements salt for enhanced security
- Validates file existence and permissions
- Logs all operations for audit trail
- Handles errors securely with proper exit codes

## Requirements

- OpenSSL must be installed
- File must be readable and writable
- Sufficient permissions to create log file