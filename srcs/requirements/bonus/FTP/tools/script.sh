#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

echo "Starting VSFTPD initialization..."

# Create the required runtime directory for vsftpd
mkdir -p /var/run/vsftpd/empty

# ============================================
# Create FTP user
# ============================================

# Check the user if already exist
if ! grep "${FTP_USER}" /etc/passwd; then
    echo "Creating user FTP..."
    # useradd → creates a new system user
    # -m → create home directory (/home/ftpuser)
    useradd -m "${FTP_USER}"

    # ============================================
    # Give user access to wordpress files
    # ============================================

    # add FTP user to the www-data group
    # usermod => user modify
    # -aG => a -> append / G -> set the groups of a user
    usermod -aG www-data "${FTP_USER}"
else
    echo "User FTP already exists, skipping..."
fi

# chpasswd → change password from stdin
# reads "username:password" format
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

# Change permissions
chmod -R u+rwx,g+rwx,o+rx /var/www/html

# ============================================
# Copy our custom config
# ============================================

# replace default vsftpd config with ours
cp /etc/conf/vsftpd.conf /etc/vsftpd.conf

# ============================================
# Start VSFTPD
# ============================================

echo "Starting VSFTPD in foreground..."

# exec → replace current process (bash) with vsftpd
# makes vsftpd PID 1 in container
# -obackground=NO → run in foreground (required for Docker)
# /etc/vsftpd.conf → use our config file
exec vsftpd -obackground=NO /etc/vsftpd.conf
