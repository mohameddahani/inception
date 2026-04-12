#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Print message
echo "Configuring Nginx..."

# Copy your WordPress config as default
cp /etc/conf/wordpress.conf /etc/nginx/nginx.conf

# Print message
echo "Starting Nginx..."

# # Start nginx in foreground (needed for Docker)
# # -g => → global setting → this tells Nginx “listen to this extra instruction I’m giving you.” like daemon off; 
# # daemon off; → don’t run in background → normally Nginx hides in the background.
# # Docker containers stop if the main program finishes. This makes Nginx stay in the foreground, so Docker keeps the container alive.
exec nginx -g "daemon off;"
