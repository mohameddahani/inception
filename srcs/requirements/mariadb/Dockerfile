# Base image
FROM debian:13

# Work directory
WORKDIR /mariadb

# Copy files from host machine to image
COPY ./conf ./conf
COPY ./tools ./tools

# Install MariaDB
RUN apt update && \
    apt install -y mariadb-server mariadb-client

# Add execute permission to script
RUN chmod +x ./tools/script.sh

# Expose MariaDB port
EXPOSE 3306

# Run script using shell (more reliable than direct execution)
ENTRYPOINT ["./tools/script.sh"]
