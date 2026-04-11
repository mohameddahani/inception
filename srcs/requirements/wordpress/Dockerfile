# Base image
FROM debian:13

# Install PHP + PHP-FPM + extensions needed for WordPress
RUN apt update -y && apt install -y \
    php \
    php-fpm \
    php-mysql \
    # php-json \
    # php-curl \
    # php-gd \
    # php-xml \
    # php-mbstring \
    # php-zip \
    wget \
    tar \
    # Create a generic symlink for whatever php-fpm8x version was installed
    && ln -s /usr/sbin/php-fpm8* /usr/sbin/php-fpm \
    && apt clean

# Set working directory
WORKDIR /var/www/html

# Download WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xvf latest.tar.gz \
    && mv wordpress/* . \
    && rm -rf wordpress latest.tar.gz

# Expose PHP-FPM port
EXPOSE 9000

# Run PHP-FPM in foreground
CMD ["php-fpm", "-F"]
