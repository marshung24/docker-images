FROM php:8.3-fpm-alpine

LABEL maintainer="Mars.Hung <tfaredxj@gmail.com>"

# Environment Type: production/development (From docker build --build-arg)
ARG APP_ENV=production
ENV APP_ENV=${APP_ENV}
# Build Date by CI/CD - environment variable
ARG BUILD_DATE_ARG=19700101.000000+0000
ENV BUILD_DATE_ARG=${BUILD_DATE_ARG}
# Short SHA for git commit - environment variable
ARG SHORT_SHA_ARG=fff0000
ENV SHORT_SHA_ARG=${SHORT_SHA_ARG}
# Error Display by CI/CD or Autoset by APP_ENV next - environment variable
ARG PHP_DISPLAY_ERRORS=Off
ARG PHP_OPCACHE_VALIDATE_TIMESTAMPS=0

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install system packages & PHP Extensions
RUN apk add --no-cache zip unzip curl linux-headers libgomp libcurl libxml2 libzip freetype libjpeg-turbo libpng icu-libs oniguruma imagemagick \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev libxml2-dev libzip-dev freetype-dev libjpeg-turbo-dev libpng-dev icu-dev oniguruma-dev imagemagick-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    # Install PHP Extensions
    && docker-php-ext-install -j$(nproc) gd zip curl bcmath pdo_mysql opcache mbstring xml sockets intl \
    # Install Redis (PECL)
    && pecl install redis imagick \
    && docker-php-ext-enable redis imagick \
    # Clean install tools
    && apk del --no-network .build-deps

# Setup PHP Environment By APP_ENV
RUN case "$APP_ENV" in \
        development) \
            echo "🔧 Development Environment..." && \
            apk add --no-cache bash shadow iproute2 iputils busybox-extras net-tools bind-tools nano wget htop vim tcpdump git openssh-client && \
            cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" && \
            echo 'export PS1="\u@\h:\w\\$ "' >> /etc/bash/bashrc \
        ;; \
        production) \
            echo "🔧 Production Environment..." && \
            cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
        ;; \
    esac

# PHP ini default
ENV PHP_EXPOSE_PHP=Off
ENV PHP_MEMORY_LIMIT=256M
ENV PHP_POST_MAX_SIZE=20M
ENV PHP_UPLOAD_MAX_FILESIZE=10M
ENV PHP_MAX_FILE_UPLOADS=20
ENV PHP_MAX_INPUT_VARS=5000
ENV PHP_MAX_EXECUTION_TIME=30
# Development:On ; Production:Off
ENV PHP_DISPLAY_ERRORS=${PHP_DISPLAY_ERRORS}
# Timezone
ENV PHP_DATE_TIMEZONE=Asia/Taipei
# Session
ENV PHP_SESSION_SAVE_HANDLER=files
ENV PHP_SESSION_SAVE_PATH=/var/lib/php/sessions
ENV PHP_SESSION_COOKIE_HTTPONLY=1

# OPcache ini defaults
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_ENABLE_CLI=1
ENV PHP_OPCACHE_JIT=tracing
ENV PHP_OPCACHE_JIT_BUFFER_SIZE=256M
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=128
ENV PHP_OPCACHE_INTERNED=8
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=10000
ENV PHP_OPCACHE_REVALIDATE_FREQUENCY=0
# Development:1 ; Production:0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=${PHP_OPCACHE_VALIDATE_TIMESTAMPS}

# PHP-FPM defaults
ENV PHP_FPM_PM=dynamic
ENV PHP_FPM_MAX_CHILDREN=400
ENV PHP_FPM_START_SERVERS=100
ENV PHP_FPM_MIN_SPARE_SERVERS=80
ENV PHP_FPM_MAX_SPARE_SERVERS=120
ENV PHP_FPM_MAX_REQUESTS=1000

# Copy configuration
COPY configs/conf.d/php.ini "${PHP_INI_DIR}/conf.d/99-php-overwrite.ini"
COPY configs/conf.d/opcache.ini "${PHP_INI_DIR}/conf.d/98-opcache.ini"
COPY configs/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

# Application root path
ENV APP_DIR=/srv/app
WORKDIR /srv/app



