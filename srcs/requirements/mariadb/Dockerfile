FROM mariadb:10.5

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

VOLUME ["/var/lib/mysql"]
EXPOSE 3306
# Use the official image entrypoint to initialize and run MariaDB
# Placeholder Dockerfile for MariaDB service
# This file intentionally does not implement runtime behavior.
# FROM alpine:3.18

LABEL service="mariadb"

COPY tools/init_db.sh /usr/local/bin/init_db.sh

RUN chmod +x /usr/local/bin/init_db.sh

ENTRYPOINT ["/usr/local/bin/init_db.sh"]