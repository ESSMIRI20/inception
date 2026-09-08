FROM mariadb:10.5

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

VOLUME ["/var/lib/mysql"]
EXPOSE 3306

LABEL service="mariadb"
