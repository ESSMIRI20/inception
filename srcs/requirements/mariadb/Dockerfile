FROM debian:12

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

LABEL service="mariadb"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]