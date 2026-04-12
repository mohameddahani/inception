# Base image
FROM debian:12

# Work directory
WORKDIR /mariadb

# Copy files from host machine to image
COPY ./conf /etc/conf
COPY ./tools /etc/tools

# Install MariaDB
RUN apt update && \
    apt install -y mariadb-server mariadb-client

# Add execute permission to script
RUN chmod +x /etc/tools/script.sh

# Expose MariaDB port
EXPOSE 3306

# Run script
CMD ["bash", "/etc/tools/script.sh"]
