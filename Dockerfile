FROM php:8.0-apache

WORKDIR "/var/www/html"

RUN apt-get update && apt-get install -y zlib1g-dev libzip-dev unzip
RUN docker-php-ext-install zip pdo pdo_mysql mysqli

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf


ENV COMPOSER_ALLOW_SUPERUSER=1
COPY composer.json /var/www/html
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

RUN composer install --prefer-source --no-interaction --no-dev --no-scripts --no-progress
RUN composer dump-autoload --optimize

#COPY . /var/www/html/





