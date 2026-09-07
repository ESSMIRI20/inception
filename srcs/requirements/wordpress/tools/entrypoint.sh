#!/bin/sh
set -e

cd /var/www/html || exit 1

DB_HOST="${WORDPRESS_DB_HOST:-mariadb:3306}"
DB_NAME="${WORDPRESS_DB_NAME:-wordpress}"
DB_USER="${WORDPRESS_DB_USER:-oessmiri_user}"
DB_PASS=""
if [ -f /run/secrets/db_password ]; then
  DB_PASS=$(cat /run/secrets/db_password)
fi

ADMIN_USER="oessmiri"
ADMIN_PASS="${DB_PASS}"
ADMIN_EMAIL="oessmiri@example.com"

# Wait for database to be reachable
DB_HOSTNAME=${DB_HOST%%:*}
until mysqladmin ping -h "$DB_HOSTNAME" --silent; do
  sleep 1
done

if [ ! -f wp-config.php ]; then
  echo "Generating wp-config.php and installing WordPress..."
  wp core config --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost="$DB_HOST" --path="/var/www/html" --quiet --allow-root
  wp core install --url="https://${DOMAIN_NAME}" --title="Inception WP" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_EMAIL" --path="/var/www/html" --skip-email --quiet --allow-root

  # create secondary user
  wp user create oessmiri_user oessmiri_user@example.com --user_pass="$DB_PASS" --role=author --path="/var/www/html" --quiet --allow-root || true
  chown -R www-data:www-data /var/www/html
fi

exec php-fpm -F
