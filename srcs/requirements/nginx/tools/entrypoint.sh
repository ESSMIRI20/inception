#!/bin/sh
set -e

mkdir -p /etc/nginx/ssl
if [ -f /run/secrets/ssl_cert ]; then
  cp /run/secrets/ssl_cert /etc/nginx/ssl/ssl.crt
fi
if [ -f /run/secrets/ssl_key ]; then
  cp /run/secrets/ssl_key /etc/nginx/ssl/ssl.key
fi
# If certificates are missing, empty, or placeholders, generate a self-signed cert
if [ ! -s /etc/nginx/ssl/ssl.crt ] || [ ! -s /etc/nginx/ssl/ssl.key ] || grep -q "REPLACE_WITH" /etc/nginx/ssl/ssl.crt 2>/dev/null; then
  echo "Generating self-signed certificate for testing..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/ssl.key -out /etc/nginx/ssl/ssl.crt \
    -subj "/CN=localhost"
fi
# Wait for the WordPress service to be resolvable before starting nginx
TRIES=0
until getent hosts wordpress >/dev/null 2>&1; do
  TRIES=$((TRIES+1))
  if [ $TRIES -gt 30 ]; then
    echo "wordpress hostname did not resolve after $TRIES seconds"
    exit 1
  fi
  sleep 1
done

exec nginx -g 'daemon off;'

