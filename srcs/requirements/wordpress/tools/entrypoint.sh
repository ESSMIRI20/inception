#!/bin/sh
set -eu

cd /var/www/html || exit 1

DB_HOST="${WORDPRESS_DB_HOST:-mariadb:3306}"
DB_NAME="${WORDPRESS_DB_NAME:-wordpress}"
DB_USER="${WORDPRESS_DB_USER:-oessmiri_user}"
DB_PASS=""
if [ -f /run/secrets/db_password ]; then
  DB_PASS=$(tr -d '\r\n' < /run/secrets/db_password)
fi

ADMIN_USER="oessmiri"
ADMIN_PASS="${DB_PASS}"
ADMIN_EMAIL="oessmiri@example.com"

wp_cli() {
  php -d memory_limit=512M /usr/local/bin/wp "$@"
}

DB_HOSTNAME=${DB_HOST%%:*}
until mysqladmin -h "$DB_HOSTNAME" -u "$DB_USER" -p"$DB_PASS" ping --silent; do
  sleep 1
done

if [ ! -f wp-config.php ] || ! grep -q "\$table_prefix" wp-config.php 2>/dev/null || ! wp_cli core is-installed --path="/var/www/html" --allow-root >/dev/null 2>&1; then
  echo "Installing WordPress core and configuration..."
  if [ ! -f wp-load.php ]; then
    wp_cli core download --allow-root --force --path="/var/www/html"
  fi
  wp_cli config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost="$DB_HOST" --path="/var/www/html" --allow-root --force
  wp_cli core install --url="https://${DOMAIN_NAME}" --title="Inception WP" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_EMAIL" --path="/var/www/html" --skip-email --allow-root
  wp_cli user create oessmiri_user oessmiri_user@example.com --user_pass="$DB_PASS" --role=author --path="/var/www/html" --allow-root || true
fi

chown -R www-data:www-data /var/www/html
exec php-fpm -F
