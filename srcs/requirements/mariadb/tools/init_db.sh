#!/bin/sh
set -e

# Initialize MariaDB datadir and create database and users on first run
DATADIR=/var/lib/mysql

if [ ! -d "$DATADIR/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  mysqld --initialize-insecure --datadir="$DATADIR" || true

  # start temporary server
  mysqld_safe --skip-networking &
  pid="$!"

  # wait for server
  until mysqladmin ping --silent; do
    sleep 1
  done

  ROOT_PASS=""; DB_PASS=""
  if [ -f /run/secrets/db_root_password ]; then
    ROOT_PASS=$(cat /run/secrets/db_root_password)
  fi
  if [ -f /run/secrets/db_password ]; then
    DB_PASS=$(cat /run/secrets/db_password)
  fi

  DB_NAME="${MYSQL_DATABASE:-wordpress}"
  DB_USER="${MYSQL_USER:-oessmiri_user}"

  echo "Configuring database..."
  # set root password if provided
  if [ -n "$ROOT_PASS" ]; then
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';"
  fi

  mysql -e "CREATE DATABASE IF NOT EXISTS \\`$DB_NAME\\`;"
  mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
  mysql -e "GRANT ALL PRIVILEGES ON \\`$DB_NAME\\`.* TO '$DB_USER'@'%';"
  mysql -e "FLUSH PRIVILEGES;"

  # stop temporary server
  mysqladmin shutdown || true
  wait "$pid" 2>/dev/null || true
  echo "MariaDB initialization complete."
fi

exec /usr/sbin/mysqld
