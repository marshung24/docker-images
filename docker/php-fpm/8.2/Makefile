SHELL := /bin/bash

VERSION := $(notdir $(CURDIR))
USERNAME := marshung24
# Git 短 SHA，若無 .git 資訊，fallback 為 unknown
SHORT_SHA := $(shell git log -1 --format='%H' 2>/dev/null | cut -c1-8)
ifeq ($(SHORT_SHA),)
SHORT_SHA := unknown
endif

# 編譯時間，格式：20250321.153045.+0800
BUILD_TIME := $(shell TZ=UTC-8 date +%Y%m%d.%H%M%S.%z)


.PHONY: all all-dev all-prod dev dev-up prod prod-up

all: all-dev all-prod

all-dev: dev dev-up

all-prod: prod prod-up

dev:
	docker build --pull --rm --no-cache \
		--build-arg APP_ENV=development \
		--build-arg PHP_DISPLAY_ERRORS=Off \
		--build-arg PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
		--build-arg BUILD_DATE_ARG=$(BUILD_TIME) \
		--build-arg SHORT_SHA_ARG=$(SHORT_SHA) \
		-t ghcr.io/$(USERNAME)/php:$(VERSION)-fpm-dev \
		-t php:$(VERSION)-fpm-dev .

dev-up:
	docker push ghcr.io/$(USERNAME)/php:$(VERSION)-fpm-dev

prod:
	docker build --pull --rm --no-cache \
		--build-arg APP_ENV=production \
		--build-arg PHP_DISPLAY_ERRORS=Off \
		--build-arg PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
		--build-arg BUILD_DATE_ARG=$(BUILD_TIME) \
		--build-arg SHORT_SHA_ARG=$(SHORT_SHA) \
		-t ghcr.io/$(USERNAME)/php:$(VERSION)-fpm-prod \
		-t php:$(VERSION)-fpm-prod .

prod-up:
	docker push ghcr.io/$(USERNAME)/php:$(VERSION)-fpm-prod

