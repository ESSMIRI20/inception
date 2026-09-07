#!/usr/bin/env bash
set -euo pipefail

# Simple integration test for the compose stack
# - builds and starts the stack
# - checks containers are running
# - waits for MariaDB to respond
# - does a quick HTTP probe to nginx on localhost:443 (insecure)

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT_DIR/srcs"

echo "Building and starting compose stack..."
mkdir -p /home/ossama/data/wp_db /home/ossama/data/wp_files
docker compose up -d --build

services=(mariadb wordpress nginx)
echo "Checking containers are running..."
for svc in "${services[@]}"; do
  echo -n " - $svc: "
  status=$(docker compose ps -q $svc | xargs -r docker inspect -f '{{.State.Running}}' || echo false)
  if [ "$status" != "true" ]; then
    echo "NOT RUNNING"
    docker compose logs $svc --tail 50
    exit 1
  fi
  echo RUNNING
done

echo "Waiting for MariaDB to respond..."
TRIES=0
until docker exec mariadb mysqladmin ping --silent >/dev/null 2>&1; do
  TRIES=$((TRIES+1))
  if [ $TRIES -gt 30 ]; then
    echo "MariaDB did not become ready in time"
    docker compose logs mariadb --tail 200
    exit 1
  fi
  sleep 2
done
echo "MariaDB is responsive."

echo "Probing Nginx on https://localhost ..."
if curl -k -sS -I https://localhost >/dev/null 2>&1; then
  echo "Nginx responded over HTTPS"
else
  echo "Nginx did not respond over HTTPS — showing logs"
  docker compose logs nginx --tail 200
  exit 1
fi

echo "All checks passed."
