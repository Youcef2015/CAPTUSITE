FROM php:7.2.0-apache
# Define if build is on AWS (1) or not (0). Default not (0).
#ARG AWS=0
ARG AWS
ENV AWS=$AWS
#ARG APP_ENV=""
ARG APP_ENV
ENV APP_ENV=$APP_ENV
ENV SYMFONY_ENV=$APP_ENV

RUN dnf update -y
RUN dnf install -y python python-pip python-requests
RUN pip install docker-compose
CMD docker-compose

# Install dependencies
RUN apt-get update && \
    apt-get install curl nano && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install AWS CLI (Necessary when using RDS)
RUN apt-get update \
        && apt-get install  -f -y python-pip \
        && pip install awscli --upgrade \
        && rm -rf /var/lib/apt/lists/* \

# Install PHP Memcached (Necessary when using multicontainer for sharing PHP Sessions)
RUN if [ "$AWS" = 1 ] ; \
        then apt-get update && apt-get install -y libmemcached-dev zlib1g-dev vim curl mysql-client \
            && pecl install memcached-3.0.4 \
            && docker-php-ext-enable memcached \
            && rm -rf /var/lib/apt/lists/* \
            && echo '; Cache Session Config' >> /usr/local/etc/php/php.ini \
            && echo 'session.save_handler = memcached' >> /usr/local/etc/php/php.ini \
            && echo 'session.save_path = "${CACHE_HOST}:${CACHE_PORT}"' >> /usr/local/etc/php/php.ini \
        ; fi

# NodeJS
RUN apt-get update && apt-get install -y wget gnupg

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash \
    && apt-get update \
    && apt-get install -y nodejs

# Install PHP PDO
RUN docker-php-ext-install pdo pdo_mysql

# Apache Conf

COPY docker/dev/default.conf /etc/apache2/sites-available/000-default.conf
COPY docker/ports.conf /etc/apache2/

# Config mellon on prod


#Copy apache2 conf
COPY docker/apache2.conf /etc/apache2/apache2.conf

# Copy source for Dockerized app

COPY /back /var/www/html/back
# Exec

#RUN chmod +x /usr/local/bin/docker-entrypoint.sh
#ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
