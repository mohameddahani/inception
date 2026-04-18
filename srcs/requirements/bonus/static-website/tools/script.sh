#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Print message
echo "Create Static Website..."

echo "<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
    </style>
</head>
<body>
    <h1 dir="rtl">وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَى</h1>
</body>
</html>" > /var/www/html/index.html



# Print message
echo "Configuring Nginx..."

# Print message
echo "Starting Nginx..."

# # Start nginx in foreground (needed for Docker)
# # -g => → global setting → this tells Nginx “listen to this extra instruction I’m giving you.” like daemon off; 
# # daemon off; → don’t run in background → normally Nginx hides in the background.
# # Docker containers stop if the main program finishes. This makes Nginx stay in the foreground, so Docker keeps the container alive.
exec nginx -g "daemon off;"
