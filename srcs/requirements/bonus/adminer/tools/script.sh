#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Print message
echo "Starting Adminer..."

# php => Runs the PHP interpreter.
# -S => Starts PHP’s built-in web server.
# 0.0.0.0:8081 => Binds the server to all network interfaces on port 8081 (accessible outside localhost, e.g. Docker or other devices).
exec php -S 0.0.0.0:8081
