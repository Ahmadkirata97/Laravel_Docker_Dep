#! /bin/bash
# Load the Encrypted credentials from the configuration file
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



# Decryption Password
decryption_password="password"

# Decrypt the credentials using openssl
Decrypted_Dbuser=$(echo "$DB_USER" | openssl enc -d -aes-256-cbc -a -pass pass:"$decryption_password")
Decrypted_Dbpassword=$(echo "$DB_PASSWORD" | openssl enc -d -aes-256-cbc -a -pass pass:"$decryption_password")

# Database Name to be created
DB_NAME="laragigs"

# Create DB Command
create_db_cmd="create database $DB_NAME;"

# Execute the command
mysql -u"$Decrypted_Dbuser" -p"$Decrypted_Dbpassword" -e "$create_db_cmd"

# Check the exit status of the previous command
if [ $? -eq 0 ]; then
    echo "Database created successfully"
else
    echo "Database not created successfully"
fi