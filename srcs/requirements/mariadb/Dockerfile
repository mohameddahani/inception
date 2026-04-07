# Base image
FROM alpine:latest

# Work directory
WORKDIR /mariadb

# Copy files from host machine to image
COPY ./tools ./conf

# Run a command when the image is building
RUN apk update && apk add mariadb mariadb-client

# Add data directory for data bases
# --user=mysql => add permisssion for mysql to write on directory of databses
# --ldata=/var/lib/mysql => Initialize database system tables as the mysql user
RUN mkdir -p /var/lib/mysql && mysql_install_db --user=mysql --ldata=/var/lib/mysql

# This tell the user or develper the service is running on port 3306 and also use it in documentation
EXPOSE 3306

# CMD defines the default command that runs when a container starts
# mariadbd-safe ==> this command start MariaDB server as the main process inside the container
# --datadir=/var/lib/mysql ==> this command tell the mariadb where he should found database system tables
CMD ["mariadbd-safe", "--datadir=/var/lib/mysql"]
