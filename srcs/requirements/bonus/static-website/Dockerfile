# Base image
FROM debian:12

# Set working directory
WORKDIR /static-website

# Install nginx
RUN apt update && \
    apt install -y nginx

# Copy files from host machine to image
COPY ./tools /etc/tools

# Add execute permission to script
RUN chmod +x /etc/tools/script.sh

# Expose HTTP port
EXPOSE 80

# Run script
CMD ["bash", "/etc/tools/script.sh"]
