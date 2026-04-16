#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

echo "Starting VSFTPD initialization..."

mkdir -p /etc/vsftpd /var/run/vsftpd/empty

# ============================================
# Create FTP user
# ============================================

# useradd → creates a new system user
# -m → create home directory (/home/ftpuser)
# -s /bin/bash → set shell to bash
useradd -m -s /bin/bash "${FTP_USER}"

# chpasswd → change password from stdin
# reads "username:password" format
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

# ============================================
# Give user access to wordpress files
# ============================================

# chown → change owner of directory
# -R → recursive (apply to all files inside)
# user:group → new owner
chown -R "${FTP_USER}:${FTP_USER}" /var/www/html

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
