# Base image
FROM debian:13

# Install nginx
RUN apt update && \
    apt install -y nginx

# Copy files from host machine to image
# COPY ./conf ./conf
# COPY ./tools ./tools

# Expose HTTP port
EXPOSE 80

# Start nginx in foreground (needed for Docker)
# -g => → global setting → this tells Nginx “listen to this extra instruction I’m giving you.” like daemon off; 
# daemon off; → don’t run in background → normally Nginx hides in the background.
# Docker containers stop if the main program finishes. This makes Nginx stay in the foreground, so Docker keeps the container alive.
CMD ["nginx", "-g", "daemon off;"]