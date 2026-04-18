# Base Image
FROM debian:12

# Set working directory
WORKDIR  /var/www/html

# Install adminer
RUN apt update -y && apt install -y \
    php \
    php-mysql \
    wget

# Download Adminer
# -O => Save the downloaded content into this exact file name
RUN wget -O index.php https://www.adminer.org/latest.php

# Copy files from host machine to image
COPY ./tools /etc/tools

# Add execute permission to script
RUN chmod +x /etc/tools/script.sh

# Expose Adminer port
EXPOSE 8080

# Run script
CMD ["bash", "/etc/tools/script.sh"]
