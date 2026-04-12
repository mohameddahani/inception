# Base image
FROM debian:12

# Install PHP + PHP-FPM + extensions needed for WordPress
RUN apt update -y && apt install -y \
    php \
    php-fpm \
    php-mysql \
    wget \
    tar \
    # Create a generic symlink for whatever php-fpm8x version was installed
    && ln -s /usr/sbin/php-fpm8* /usr/sbin/php-fpm \
    && apt clean

# Set working directory
WORKDIR /var/www/html

# Copy files from host machine to image
COPY ./conf /etc/conf
COPY ./tools /etc/tools

# Add execute permission to script
RUN chmod +x /etc/tools/script.sh

# Expose PHP-FPM port
EXPOSE 9000

# Run script
CMD ["bash", "/etc/tools/script.sh"]
