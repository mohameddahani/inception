# Base image
FROM debian:12

# Install FTP
RUN apt update -y && apt install -y vsftpd

# Set working directory
WORKDIR /FTP

# Copy files from host machine to image
COPY ./tools /etc/tools

# Add execute permission to script
RUN chmod +x /etc/tools/script.sh

# Expose PHP-FPM port
EXPOSE 9000

# Run script
CMD ["bash", "/etc/tools/script.sh"]
