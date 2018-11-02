FROM php:7.2.0-apache

ARG APP_ENV
ENV APP_ENV=$APP_ENV
ENV SYMFONY_ENV=$APP_ENV

# NodeJS
RUN apt-get update && apt-get install -y wget gnupg

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash \
    && apt-get update \
    && apt-get install -y nodejs

# Install PHP PDO
RUN docker-php-ext-install pdo pdo_mysql

# Composer

RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer
WORKDIR /app
COPY . ./
RUN composer install --no-dev --no-interaction -o

# Apache Conf

COPY docker/dev/default.conf /etc/apache2/sites-available/000-default.conf
COPY docker/ports.conf /etc/apache2/

RUN a2enmod rewrite headers proxy proxy_http

# Php Conf (Be careful to not erase previously php conf like memcached)
COPY docker/php.ini /usr/local/etc/php/php-ini
RUN cat /usr/local/etc/php/php-ini >> /usr/local/etc/php/php.ini \
    && rm /usr/local/etc/php/php-ini
#Copy apache2 conf
COPY docker/apache2.conf /etc/apache2/apache2.conf

# Copy source for Dockerized app

COPY /back /var/www/html/back

WORKDIR /var/www/html/back
#RUN chmod +x /usr/local/bin/docker-entrypoint.sh
#ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
