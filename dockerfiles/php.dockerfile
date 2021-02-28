FROM php:8.0-fpm

#Install xdebug
RUN pecl install xdebug-3.0.3 && docker-php-ext-enable xdebug

WORKDIR /var/www/html

COPY src .

RUN docker-php-ext-install pdo pdo_mysql

RUN adduser laravel --disabled-password --gecos ""

USER laravel