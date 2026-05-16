FROM alpine:3.22

RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-ctype \
    php82-mysqli \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-phar \
    php82-pecl-redis \
    wget \
    unzip \
    mariadb-client \
    fcgi \
    php82-tokenizer 

RUN ln -sf /usr/bin/php82 /usr/bin/php

# Instalamos wp-cli (herramienta fundamental para configurar WP por comandos)
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Configuramos PHP-FPM para que escuche en el puerto 9000
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php82/php-fpm.d/www.conf

WORKDIR /var/www/html/wordpress

COPY requirements/wordpress/tools/setup.sh /usr/local/bin/setup.sh
COPY requirements/wordpress/tools/healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/setup.sh /usr/local/bin/healthcheck.sh

EXPOSE 9000

ENTRYPOINT ["sh", "/usr/local/bin/setup.sh"]
