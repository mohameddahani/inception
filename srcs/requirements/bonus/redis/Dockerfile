# Base image
FROM debian:12

# Work directory
WORKDIR /redis

# Copy files from host machine to image
COPY ./tools /etc/tools

# Install Redis
RUN apt update -y && apt install -y redis-server

# Expose REDIS port
EXPOSE 6379

# Run script
CMD ["bash", "/etc/tools/script.sh"]