FROM wordpress:php7.4-fpm

# Use the official WordPress image with PHP-FPM
EXPOSE 9000

LABEL service="wordpress"

COPY tools/entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]