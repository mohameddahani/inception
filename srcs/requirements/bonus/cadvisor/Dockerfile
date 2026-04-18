# Base Image
FROM debian:12

# Install wget
RUN apt update -y && apt install -y wget

# Install cadvisor and change permission
RUN wget -O /usr/local/bin/cadvisor \
    https://github.com/google/cadvisor/releases/download/v0.56.2/cadvisor-v0.56.2-linux-amd64 \
    && chmod +x /usr/local/bin/cadvisor

# Expose port of cadvisor
EXPOSE 8080

# Run cadvisor
CMD ["cadvisor", "--port=8080"]
