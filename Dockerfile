FROM php:7.4-fpm-alpine


# Setup GD extension
RUN apk add --no-cache \
      freetype \
      libjpeg-turbo \
      libpng \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      # --with-png=/usr/include/ \ # No longer necessary as of 7.4; https://github.com/docker-library/php/pull/910#issuecomment-559383597
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apk del --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && rm -rf /tmp/*

RUN apk add libzip-dev

RUN docker-php-ext-install pdo pdo_mysql zip bcmath

# RUN apk upgrade --update && apk --no-cache add \
#     autoconf tzdata openntpd file g++ gcc binutils isl libatomic libc-dev musl-dev make re2c libstdc++ libgcc libcurl curl-dev binutils-libs mpc1 mpfr3 gmp libgomp coreutils freetype-dev libjpeg-turbo-dev libltdl libmcrypt-dev libpng-dev openssl-dev libxml2-dev expat-dev \
#     && docker-php-ext-install -j$(nproc) iconv mysqli pdo pdo_mysql curl bcmath mcrypt mbstring json xml zip opcache \
# 	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
# 	&& docker-php-ext-install -j$(nproc) gd

# TimeZone
# RUN cp /usr/share/zoneinfo/Asia/Bangkok /etc/localtime \
# && echo "Asia/Bangkok" >  /etc/timezone

# Install Composer && Assets Plugin
# RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
# && composer global require --no-progress "fxp/composer-asset-plugin:~1.2" \
# && apk del tzdata \
# && rm -rf /var/cache/apk/*

EXPOSE 9000

CMD ["php-fpm"]
