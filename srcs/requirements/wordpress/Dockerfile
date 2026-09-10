FROM debian:12

RUN apt-get update && \
    apt-get install -y \
        php8.2-fpm \
        php8.2-mysql \
        php8.2-curl \
        php8.2-gd \
        php8.2-intl \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-zip \
        default-mysql-client \
        curl \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENV WP_CLI_PHP_ARGS="-d memory_limit=512M"

EXPOSE 9000

LABEL service="wordpress"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]