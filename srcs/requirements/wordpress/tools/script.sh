#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Download WordPress
cd /var/www/html

wget https://wordpress.org/latest.tar.gz \
    && tar -xvf latest.tar.gz \
    && mv wordpress/* . \
    && rm -rf wordpress latest.tar.gz

# Delete the default Config of wordpress
rm -rf ./wp-config-sample.php

# Copy Config of wordpress
cp /etc/conf/wp-config.php /var/www/html

# Print Message
echo "Wordpress is Downloaded Successfully !"

# The sed (Stream Editor) command is used to modify text inside files.
# -i means "in-place", so the file is modified directly (not just printed).
# s|A|B means substitute A with B.
# Here we replace PHP-FPM socket mode with TCP mode (port 9000).
sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 0.0.0.0:9000|' \
/etc/php/*/fpm/pool.d/www.conf

# Print Message
echo "Starting PHP-FPM..."

# Run PHP-FPM in foreground
exec php-fpm -F
