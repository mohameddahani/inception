#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Start Redis as main process (PID 1)
# --daemonize no => is mean start in foreground
# --protected-mode no => disable protected-mode to skip passwod and enable connection from other containers
# --bind 0.0.0.0 => listen to all other containers
exec redis-server --daemonize no --protected-mode no --bind 0.0.0.0
