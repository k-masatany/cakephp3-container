FROM php:7.1.22-apache

RUN apt-get update && \
  apt-get install -y \
  libpq-dev \
  libxml2 \
  libxml2-dev \
  libicu-dev \
  libmcrypt-dev \
  git \
  ssl-cert \
  rsyslog \
  cron \
  vim \
  zlib1g-dev && \
  docker-php-ext-install \
  pdo_pgsql \
  pdo_mysql \
  mbstring \
  xml \
  pdo \
  intl \
  mcrypt \
  opcache \
  zip
RUN apt-get update && apt-get install -y \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  && docker-php-ext-install -j$(nproc) iconv mcrypt \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd

COPY config/php.ini /usr/local/etc/php/
COPY config/000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
RUN a2enmod rewrite

RUN service cron start

ENV CAKE_ENV_MODE production

EXPOSE 80
