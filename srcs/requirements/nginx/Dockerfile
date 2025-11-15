FROM debian:12

RUN apt update && apt install -y nginx curl openssl \
 && mkdir -p /etc/nginx/ssl \
 && openssl req -x509 -nodes \
      -out /etc/nginx/ssl/inception.crt \
      -keyout /etc/nginx/ssl/inception.key \
      -subj "/C=FR/ST=OCC/L=Perpignan/O=42/CN=pmenard.42.fr/UID=pmenard"

RUN mkdir -p /var/run/nginx

#select correct conf file
COPY conf/nginx.conf /etc/nginx/conf.d/nginx.conf

RUN chmod 755 /var/www/html
#allow Nginx to create/modify files
RUN chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]