#!/bin/sh

# set -e

# Add data directory for data bases
# --user=mysql => add permisssion for mysql to write on directory of databses
# --ldata=/var/lib/mysql => Initialize database system tables as the mysql user
mkdir -p /var/lib/mysql && mysql_install_db --user=mysql --ldata=/var/lib/mysql

# CMD defines the default command that runs when a container starts
# mariadbd-safe ==> this command start MariaDB server as the main process inside the container
# --datadir=/var/lib/mysql ==> this command tell the mariadb where he should found database system tables
exec mariadbd-safe && --datadir=/var/lib/mysql