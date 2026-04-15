#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Download WordPress
cd /var/www/html

# Downloads WordPress files from wordpress.org
# --path=/var/www/html => where to download WordPress to
# --allow-root => by default WP-CLI refuses to run as root (security), in Docker we are always root, so this flag is required, without it → ERROR: "You are attempting to run as root"
# -f => mean file
# the condition if success it will return 0 and if it fail will return 1
# 0 = true
# 1 = false
if [ ! -f "/var/www/html/wp-includes/version.php" ]; then
    echo "Downloading WordPress..."
    wp core download \
    --path=/var/www/html \
    --allow-root
else
    echo "WordPress already exists, skipping..."
fi

# Connect to Database
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Connect to Database..."
    wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$DB_HOST" \
    --allow-root
else
    echo "Database already Connected, skipping..."
fi

# runs WordPress installation (like the web installer)
# --skip-email don't send welcome email after install important in Docker → no mail server configured
if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --path=/var/www/html \
        --url="${WP_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
else
    echo "WordPress already installed, skipping..."
fi

# Create normal user
if ! wp user get "${WP_USER}" --path=/var/www/html --allow-root; then
    echo "Creating user..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --path=/var/www/html \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root
else
    echo "User already exists, skipping..."
fi

# Print Message
echo "Wordpress is Downloaded Successfully !"

# The sed (Stream Editor) command is used to modify text inside files.
# -i means "in-place", so the file is modified directly (not just printed).
# s|A|B means substitute A with B.
# Here we replace PHP-FPM socket mode with TCP mode (port 9000).
sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 0.0.0.0:9000|' \
/etc/php/*/fpm/pool.d/www.conf

# Dont clear env of php-fpm befor start the process
# Remove Comment from ;clear_env = no
sed -i 's|;clear_env = no|clear_env = no|' \
/etc/php/*/fpm/pool.d/www.conf

# Config of Redis
# wp config set => is mean set on config file => wp-config.php
# --raw => mean set the value in wp-config.php as interger not string
# wp redis enable => Enable Redis cache on this file => wp-content/object-cache.php
# wp config set WP_REDIS_HOST ${WP_REDIS_HOST} --raw
# wp config set WP_REDIS_PORT ${WP_REDIS_PORT} --raw
# wp plugin install redis-cache --activate
# wp redis enable

# # Print Message
# wp redis status

# Print Message
echo "Starting PHP-FPM..."

# Run PHP-FPM in foreground
exec php-fpm -F
