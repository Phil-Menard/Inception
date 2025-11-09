# Dockerfile WordPress
ARG BASE_IMAGE=debian:11-slim
FROM $BASE_IMAGE

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        php-fpm \
        php-mysql \
        php-cli \
        php-curl \
        php-gd \
        php-mbstring \
        php-xml \
        php-xmlrpc \
        php-soap \
        php-intl \
        default-mysql-client \
        wget unzip \
        curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY ./entrypoint.sh /entrypoint.sh
COPY ./create_admin.php /var/www/html/

RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    mv wordpress/* . && \
    rm -rf wordpress latest.zip

RUN chown -R www-data:www-data /var/www/html

# 🔧 Fix pour PHP-FPM
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php
RUN sed -i "s|listen = /run/php/php7.4-fpm.sock|listen = 9000|" /etc/php/7.4/fpm/pool.d/www.conf

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]
