# Base image
FROM debian:12

# Install PHP + PHP-FPM + extensions needed for WordPress
RUN apt update -y && apt install -y \
    php \
    php-fpm \
    php-mysql \
    curl \
    && ln -s /usr/sbin/php-fpm8* /usr/sbin/php-fpm \
    && apt clean

# Install Wordpress CLI
# -O → save file with same name (wp-cli.phar)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set working directory
WORKDIR /var/www/html

# Copy files from host machine to image
COPY ./tools /etc/tools

# Add execute permission to script
RUN chmod +x /etc/tools/script.sh

# Expose PHP-FPM port
EXPOSE 9000

# Run script
CMD ["bash", "/etc/tools/script.sh"]
