#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Pint message
echo "Starting VSFTPD in foreground..." 


# -o => Allows you to set a single configuration option directly from the command line.
# background=NO => run the server in foreground
# /etc/vsftpd.conf => configuration of FTP server
exec vsftpd -obackground=NO /etc/vsftpd.conf
