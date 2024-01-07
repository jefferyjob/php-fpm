FROM php:8.2-fpm-alpine

ARG TZ
ARG CONTAINER_PACKAGE_URL

# RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

RUN apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone \
    && apk --no-cache add bash \
    && apk --no-cache add vim \
    && apk --update add --no-cache --virtual .build-deps autoconf g++ libtool make curl-dev gettext-dev linux-headers

# Fix: https://github.com/docker-library/php/issues/240
RUN apk add gnu-libiconv libstdc++ --no-cache --repository http://${CONTAINER_PACKAGE_URL}/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php


# Install composer and change it's cache home
RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar \
    && chmod +x /usr/bin/composer \
    && mkdir -p /tmp/composer
ENV COMPOSER_HOME=/tmp/composer

# imagick
# pdo_mysql,mysqli,mysql,redis,mbstring,gd,curl,apcu,opcache,imagick,xdebug,bcmath,fileinfo
# PECL 扩展
RUN pecl install redis-5.3.7 \
	&& pecl install xdebug-3.2.1 \
    && pecl install opcache-7.0.5 \
	&& docker-php-ext-enable redis xdebug opcache

# 其他扩展

WORKDIR /www