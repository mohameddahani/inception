#!/bin/bash

# The set -e command is a setting used in shell scripts (like bash or sh) that tells the script to exit immediately if any command fails.
set -e

# Print message
echo "Starting MariaDB initialization..."

# Start MariaDB
service mariadb start

# Wait until MariaDB is ready
until mysqladmin ping --silent; do
    sleep 1
done

# Create database and user
# '%' => allows the user to connect from ANY host (any container / any IP)
# CREATE DATABASE => creates the database if it does not already exist
# CREATE USER => creates a new MySQL user with a password
# GRANT ALL PRIVILEGES => gives the user full permissions (SELECT, INSERT, UPDATE, DELETE, etc.)
# on all tables (*) inside the database (my_wordpress_db)
# FLUSH PRIVILEGES => reloads the privilege tables so changes take effect immediately
mariadb -u root << MYSQL_QUERIES
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
MYSQL_QUERIES

echo "MariaDB initialization complete."

# Stop service (clean shutdown)
service mariadb stop

# Start MariaDB as main process (PID 1)
# exec → makes MariaDB the main container process (important for Docker signals)
#
# --user=mysql → runs MariaDB with limited safe permissions (not root)
#
# --datadir=/var/lib/mysql → where all database files are stored
# (tables, system DB, logs, etc.)
#
# --bind-address=0.0.0.0 → allows connections from other containers (not only localhost)
exec mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
