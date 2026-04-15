#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Start Redis as main process (PID 1)
# --daemonize no => is mean start in foreground
exec redis-server --daemonize no
