# Base image
FROM alpine:latest

# Work directory
WORKDIR /mariadb

# Copy files from host machine to image
COPY ./conf ./conf
COPY ./tools ./tools

# Add Permission of execute script
RUN chmod +x ./tools/script.sh

# Run a command when the image is building
RUN apk update && apk add mariadb mariadb-client

# This tell the user or develper the service is running on port 3306 and also use it in documentation
EXPOSE 3306

CMD ["./tools/script.sh"]
