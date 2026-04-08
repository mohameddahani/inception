# Base image
FROM alpine:latest

# Install nginx
RUN apk update && apk add nginx

# Copy nginx configuration files
COPY ./conf /etc/nginx/conf.d/
COPY ./tools .

# Expose HTTP port
EXPOSE 80

# Start nginx in foreground (needed for Docker)
# -g => → global setting → this tells Nginx “listen to this extra instruction I’m giving you.” like daemon off; 
# daemon off; → don’t run in background → normally Nginx hides in the background.
# Docker containers stop if the main program finishes. This makes Nginx stay in the foreground, so Docker keeps the container alive.
CMD ["nginx", "-g", "daemon off;"]