#!/bin/sh

set -eu

DATADIR="/var/lib/mysql"

mkdir -p /run/mysqld
mkdir -p "$DATADIR"

chown -R mysql:mysql "$DATADIR" /run/mysqld

if [ ! -d "$DATADIR/mysql" ]; then
    echo "Initializing MariaDB data directory..."

    mariadb-install-db \
        --user=mysql \
        --datadir="$DATADIR"

    mysqld_safe --user=mysql --skip-networking &

    pid="$!"

    until mysqladmin ping --silent; do
        sleep 1
    done

    ROOT_PASS=""
    DB_PASS=""

    if [ -f /run/secrets/db_root_password ]; then
        ROOT_PASS=$(tr -d '\r\n' < /run/secrets/db_root_password)
    fi

    if [ -f /run/secrets/db_password ]; then
        DB_PASS=$(tr -d '\r\n' < /run/secrets/db_password)
    fi

    DB_NAME="${MYSQL_DATABASE:-wordpress}"
    DB_USER="${MYSQL_USER:-oessmiri_user}"

    echo "Configuring database..."

    if [ -n "$ROOT_PASS" ]; then
        mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';"
    fi

    mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

    mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"

    mysql -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';"

    mysql -e "FLUSH PRIVILEGES;"

    mysqladmin shutdown || true

    wait "$pid" 2>/dev/null || true

    echo "MariaDB initialization complete."
fi

exec /usr/sbin/mysqld --user=mysql --console