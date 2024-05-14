FROM php:8.1-fpm-alpine

RUN apk update && apk add --update nodejs npm yarn \
    composer php-pdo_sqlite php-pdo_mysql php-pdo_pgsql php-simplexml php-fileinfo php-dom php-tokenizer php-xml php-xmlwriter php-session \
    openrc bash busybox-extras curl zip git

RUN docker-php-ext-install pdo

WORKDIR /app