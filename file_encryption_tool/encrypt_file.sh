#!/usr/bin/bash

# This script encrypts and decrypts files using a password. Implement a safe encryption method and handle key management securely.
# It focuses on basic cryptography, input/output redirection, secure coding

# Handle errors
set -euo pipefail
# Check if the correct number of arguments is provided
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 [--encrypt|--decrypt] <password> <file>"
    exit 1
fi
# Check if the file exists 
if [ ! -f "$3" ]; then
    echo "File $3 does not exist."
    exit 1
fi
# Check if the file is readable
if [ ! -r "$3" ]; then
    echo "File $3 is not readable."
    exit 1
fi
# Check if the file is writable
if [ ! -w "$3" ]; then
    echo "File $3 is not writable."
    exit 1
fi

# Configure logging
log_file="file_encryption.log"
exec 2>>${log_file} 2>&1
write_log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" 
}
# Function to encrypt a file
encrypt_file() {
    local password="$1"
    local file="$2"
    write_log "Encrypting file $file"
    openssl enc -aes-256-cbc -salt -in "$file" -out "$file.enc" -k "$password"
    if [ $? -eq 0 ]; then
        echo "File $file encrypted successfully."
        write_log "File $file encrypted successfully."
    else
        echo "Error encrypting file $file."
        write_log "Error encrypting file $file."
        exit 1
    fi
}

# Function to decrypt a file
decrypt_file() {
    local password="$1"
    local file="$2"
    write_log "Decrypting file $file"
    openssl enc -d -aes-256-cbc -in "$file" -out "${file%.enc}" -k "$password"
    if [ $? -eq 0 ]; then
        echo "File $file decrypted successfully."
        write_log "File $file decrypted successfully."
    else
        echo "Error decrypting file $file."
        write_log "Error decrypting file $file."
        exit 1
    fi
}
# Main script logic
operation="$1"
password="$2"
file="$3"
if [ "$operation" == "--encrypt" ]; then
    encrypt_file "$password" "$file"
elif [ "$operation" == "--decrypt" ]; then
    decrypt_file "$password" "$file"
else
    echo "Invalid operation. Use --encrypt or --decrypt."
    exit 1
fi
