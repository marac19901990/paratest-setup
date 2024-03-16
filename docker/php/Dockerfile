FROM php:8.2-cli

RUN apt-get update && apt-get install -y  \
    git \
    curl \
    zip \
    make \
    && apt-get clean

RUN curl -sS https://getcomposer.org/installer | php

RUN mv composer.phar /usr/local/bin/composer

WORKDIR /var/www/marac19901990/paratest-bundle