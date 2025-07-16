FROM php:8.2-cli

RUN pecl install redis && docker-php-ext-enable redis

WORKDIR /var/www/html