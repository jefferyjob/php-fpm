FROM php:8.2-fpm-alpine

ARG TZ
ARG CONTAINER_PACKAGE_URL

RUN apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone \
    && apk --no-cache add bash \
    && apk --no-cache add vim \
    && apk --update add --no-cache --virtual .build-deps autoconf g++ libtool make curl-dev gettext-dev linux-headers openssl

# Fix: https://github.com/docker-library/php/issues/240
RUN apk add gnu-libiconv libstdc++ --no-cache --repository http://${CONTAINER_PACKAGE_URL}/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# PHP扩展
ENV IPE_DEBUG=1
RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
      gd imagick apcu http grpc mysqli opcache pdo_mysql pdo_pgsql protobuf xdebug redis zip

# Install composer and change it's cache home
RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar \
    && chmod +x /usr/bin/composer \
    && mkdir -p /tmp/composer
ENV COMPOSER_HOME=/tmp/composer

WORKDIR /www

# 安装Nginx和Supervisor
RUN apk add --no-cache nginx supervisor
# 启动Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]