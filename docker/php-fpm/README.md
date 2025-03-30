# Build PHP-FPM Docker Image

## Build php-fpm using "make"
```sh
# Goto PHP-FPM-${VERSION} Directory - ex. PHP-HPM 7.4
$ cd docker/php-fpm/7.4-fpm-alpine

# Build Prod image
$ make prod

# Push Prod image to GHCR
$ make prod-up

# Build Prod image and push to GHCR
$ make prod-all

# Build Dev image
$ make dev

# Push Dev image to GHCR
$ make dev-up

# Build Dev image and push to GHCR
$ make dev-all

# Build Prod&Dev image and push both
$ make all
```

## Manually build php-fpm

```bash
# Build parameters
VERSION=$(basename "$PWD")
USERNAME=marshung24
SHORT_SHA=`git log -1 --format='%H' | cut -c1-8`
BUILD_TIME=`TZ=UTC-8 date +%Y%m%d.%H%M%S.%z`

# Move into Dockerfile dir
cd docker/php-fpm/${VERSION}

# Build prod image & push
## Build
docker build --pull --rm --no-cache \
    --build-arg APP_ENV=production \
    --build-arg PHP_DISPLAY_ERRORS=Off \
    --build-arg PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    --build-arg BUILD_DATE_ARG=${BUILD_TIME} \
    --build-arg SHORT_SHA_ARG=${SHORT_SHA} \
    -t ghcr.io/${USERNAME}/php:${VERSION} \
    -t php:${VERSION} .

## Push
docker push ghcr.io/${USERNAME}/php:${VERSION}


# Build dev image & push
## Build
docker build --pull --rm --no-cache \
    --build-arg APP_ENV=development \
    --build-arg PHP_DISPLAY_ERRORS=On \
    --build-arg PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    --build-arg BUILD_DATE_ARG=${BUILD_TIME} \
    --build-arg SHORT_SHA_ARG=${SHORT_SHA} \
    -t ghcr.io/${USERNAME}/php:${VERSION}-dev \
    -t php:${VERSION}-dev .

## Push
docker push ghcr.io/${USERNAME}/php:${VERSION}-dev
```

## Troubleshooting
### Run container
```sh
# 使用互動模式(-it)啟動容器並進入到bash，容器名稱(--name) php-fpm-dev 、映像檔 php:7.4-fpm-alpine-dev ，埠號映射(-p) 9000 to host:9000，用完即關(--rm)
$ docker run -it --rm -p 9000:9000 --name php-fpm-dev php:7.4-fpm-alpine-dev bash

# 使用服務模式(-d)啟動容器
$ docker run -d --name php-fpm-dev php:7.4-fpm-alpine-dev

# 進入容器 - 使用互動模式(-it)
$ docker exec -it php-fpm-dev sh

# 查看php模組
$ php -m

# 查看php執行中參數
$ php -i

# 停止並移除容器
$ docker stop php-fpm-dev
$ docker rm php-fpm-dev

# 強制移除(-f)容器
$ docker rm -f php-fpm-dev
```

## Referance
1. [PHP: The configuration file](https://www.php.net/manual/en/configuration.file.php#configuration.file): Environment variables can be referenced within configuration values in php.ini as shown below.
2. [Docker PHP/PHP-FPM Configuration via Environment Variables](https://jtreminio.com/blog/docker-php-php-fpm-configuration-via-environment-variables/) : A little-known fact is that PHP’s INI file (and PHP-FPM conf, too!) can be configured normally,but it can also read env vars!
3. [PHP Modules Toggled via Environment Variables](https://jtreminio.com/blog/php-modules-toggled-via-environment-variables/)
4. [docker-php-fpm](https://github.com/digitalascetic/docker-php-fpm) : php-{VERSION}-fpm-alpine images container configurable through environment variables.
5. [Configure php-fpm to access environment variables in docker](https://serverfault.com/questions/813368/configure-php-fpm-to-access-environment-variables-in-docker)
6. [How to make php-fpm read environment variables?]() https://github.com/docker-library/php/issues/1217)




