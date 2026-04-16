# Base image
FROM debian:12

# Install FTP
RUN apt update -y && apt install -y vsftpd

# Set working directory
WORKDIR /FTP

# Copy files from host machine to image
COPY ./tools /etc/tools
COPY ./conf /etc/conf

# Add execute permission to script
RUN chmod +x /etc/tools/script.sh

# Expose FTP port
# Control/Command
EXPOSE 21
# Send data back to the client
EXPOSE 20

# Passive mode port range
EXPOSE 21100-21110

# Run script
CMD ["bash", "/etc/tools/script.sh"]
