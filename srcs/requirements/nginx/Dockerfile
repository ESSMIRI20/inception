FROM nginx:1.18

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 443

CMD ["/usr/local/bin/entrypoint.sh"]
LABEL service="nginx"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
