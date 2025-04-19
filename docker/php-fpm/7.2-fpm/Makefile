# 使用 bash 作為執行 shell
SHELL := /bin/bash

# 取得當前目錄名稱作為版本號，例如當前目錄為 php74，則 VERSION=php74
VERSION := $(notdir $(CURDIR))
# Docker Hub 或 GHCR 使用的帳號名稱
USERNAME := marshung24
# 從 Git 取得最後一次 commit 的 SHA 前 8 碼，若無法取得（例如不是 Git repo），則使用 unknown
SHORT_SHA := $(shell git log -1 --format='%H' 2>/dev/null | cut -c1-8)
ifeq ($(SHORT_SHA),)
SHORT_SHA := unknown
endif

# 產生建置時間，格式為：20250321.153045.+0800，方便追蹤版本
BUILD_TIME := $(shell TZ=UTC-8 date +%Y%m%d.%H%M%S.%z)

# 宣告 phony target（非檔案目標）
.PHONY: all dev-all prod-all dev dev-up prod prod-up

# 主目標：同時執行 dev-all 與 prod-all
all: dev-all prod-all

# dev-all 會依序執行 dev 與 dev-up
dev-all: dev dev-up

# prod-all 會依序執行 prod 與 prod-up
prod-all: prod prod-up

# 建立開發環境用的 Docker image
dev:
	docker build --pull --rm --no-cache \
		--build-arg APP_ENV=development \
		--build-arg PHP_DISPLAY_ERRORS=Off \
		--build-arg PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
		--build-arg BUILD_DATE_ARG=$(BUILD_TIME) \
		--build-arg SHORT_SHA_ARG=$(SHORT_SHA) \
		-t ghcr.io/$(USERNAME)/php:$(VERSION)-dev \
		-t php:$(VERSION)-dev .

# 將開發環境的 image push 到 GHCR
dev-up:
	docker push ghcr.io/$(USERNAME)/php:$(VERSION)-dev

# 建立正式環境用的 Docker image
prod:
	docker build --pull --rm --no-cache \
		--build-arg APP_ENV=production \
		--build-arg PHP_DISPLAY_ERRORS=Off \
		--build-arg PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
		--build-arg BUILD_DATE_ARG=$(BUILD_TIME) \
		--build-arg SHORT_SHA_ARG=$(SHORT_SHA) \
		-t ghcr.io/$(USERNAME)/php:$(VERSION) \
		-t php:$(VERSION) .

# 將正式環境的 image push 到 GHCR
prod-up:
	docker push ghcr.io/$(USERNAME)/php:$(VERSION)

