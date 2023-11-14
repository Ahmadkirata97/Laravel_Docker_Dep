#!/bin/bash
# Encrypt the database credentials using OpenSSL
echo "Hello, Decryption"

# Create temporary files
user_file=$(mktemp)
password_file=$(mktemp)
encryption_password="password"

# Store the credentials in temporary files
echo -n "root" > "$user_file"
echo -n "password" > "$password_file"

# Encrypt the credentials
Encrypted_user_name=$(openssl enc -aes-256-cbc -a -salt -in "$user_file" -pass pass:"$encryption_password")
Encrypted_password=$(openssl enc -aes-256-cbc -a -salt -in "$password_file" -pass pass:"$encryption_password")

# Store the encrypted values in another file
echo "DB_USER=\"$Encrypted_user_name\"" > /etc/config.conf
echo "DB_PASSWORD=\"$Encrypted_password\"" >> /etc/config.conf

# Clean up temporary files
rm "$user_file" "$password_file"