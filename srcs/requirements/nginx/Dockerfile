# Base image
FROM debian:12

# Install nginx
RUN apt update && \
    apt install -y nginx

# Copy files from host machine to image
COPY ./conf /etc/conf
COPY ./tools /etc/tools

# Expose HTTP port
EXPOSE 80

# Run script
CMD ["bash", "/etc/tools/script.sh"]
