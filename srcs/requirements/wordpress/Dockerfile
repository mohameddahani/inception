# Base image
FROM alpine:latest

# Install PHP + PHP-FPM + extensions needed for WordPress
RUN apk update && apk add \
    php \
    php-fpm \
    php-mysqli \
    php-json \
    php-session \
    php-opcache \
    php-gd \
    php-curl \
    php-xml \
    php-mbstring \
    wget \
    tar \
    # Create a generic symlink for whatever php-fpm8x version was installed
    && ln -s /usr/sbin/php-fpm8* /usr/sbin/php-fpm

# Create directory for WordPress
WORKDIR /var/www/html

# Download WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xvf latest.tar.gz \
    && mv wordpress/* . \
    && rm -rf wordpress latest.tar.gz

# ! CONF php-fpm to listen on other containers

# Run PHP-FPM
# -F makes php-fpm run in foreground so the Docker container keeps running.
CMD ["php-fpm", "-F"]