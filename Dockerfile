FROM nginx

RUN mkdir /etc/nginx/certs
RUN mkdir /etc/nginx/clients

COPY nginx/etc /etc/nginx/
COPY nginx/html /usr/share/nginx/html/

CMD ["/etc/nginx/run-nginx.sh"]