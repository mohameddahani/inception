#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Print message
echo "Configuring Nginx..."

# Copy your WordPress config as default
cp /etc/conf/wordpress.conf /etc/nginx/nginx.conf

# Create a folder to store certicate
mkdir -p /etc/nginx/ssl

# Generate the keys of ssl and certifecate
# openssl req => Start a certificate request process
# -x509 => Create a self-signed certificate instead of a CSR (Certificate Signing Request) Used for: development / local HTTPS (like localhost) / testing Nginx SSL
# -nodes => “No DES encryption” / The private key will NOT be password protected
# -days 365 => Certificate is valid for 365 days
# -newkey => rsa:2048 => Generate a new private key + certificate at the same time. / rsa → encryption algorithm / 2048 → key size in bits
# -keyout => Where to save the PRIVATE KEY
# -out => Where to save the CERTIFICATE
# -subj "/CN=localhost" => is used to fill certificate identity information automatically without asking you questions interactively.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/CN=localhost"

# Print message
echo "Starting Nginx..."

# # Start nginx in foreground (needed for Docker)
# # -g => → global setting → this tells Nginx “listen to this extra instruction I’m giving you.” like daemon off; 
# # daemon off; → don’t run in background → normally Nginx hides in the background.
# # Docker containers stop if the main program finishes. This makes Nginx stay in the foreground, so Docker keeps the container alive.
exec nginx -g "daemon off;"
