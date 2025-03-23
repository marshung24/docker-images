# GitHub Container Registry設定及使用

## 說明
記錄GitHub Container Registry的設定與使用方式。


## 一、GitHub Container Registry（ghcr.io）簡介
GitHub 的 Docker registry URL 為：

    ghcr.io

當Repo網址為：

    github.com/username/repo

Repo 的容器映像會是：

    ghcr.io/username/repo

## 二、GitHub Container Registry
### 登入
使用 Personal Access Token (PAT) 來登入：
```sh
echo <YOUR_GITHUB_TOKEN> | docker login ghcr.io -u <YOUR_GITHUB_USERNAME> --password-stdin
```
- 取得方式：GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens or classic tokens（需勾選 read:packages, write:packages, delete:packages）

### 登出
```sh
$ docker logout ghcr.io
```

## 映像檔管理
### 上傳
```sh
# 使用 docker push 推送映像，需先登入過 GitHub Container Registry
$ docker push ghcr.io/<username>/<image>:tag
```

### 下載
```sh
# 使用 docker pull 拉取映像
docker pull ghcr.io/<username>/<image>:tag
```

### 設定標籤
```sh
# 設定標籤以便推送
$ docker tag LOCAL_IMAGE ghcr.io/OWNER/IMAGE[:TAG]
```

### 刪除本地映像
```sh
# 刪除本地映像
$ docker rmi IMAGE_ID
```

### 查看本地映像列表（非 registry）
```sh
# 查看本機映像
$ docker images
```
> 查看 GHCR 需從 WebUI 、 GitHub CLI (gh) 、 Github REST API

## 權限管理
### 路徑：
- `Github` => `Packages` => `<YOUR_PACKAGE>` => `Package settings`

### 權限種類
- Github Actions access
- Codespaces access
- Team/People access
- Package Visibility
- Delete this package

> ghcr.io上傳的Image預設為Private


## 其他
### 檢查docker login狀況
```sh
# 查看 Docker 的憑證檔案
$ cat ~/.docker/config.json
```
```json
{
  "auths": {
    "ghcr.io": {},
  },
  "credsStore": "desktop"
}
```
> `auths` 底下列出曾經 login 過的 registry。


## Log
- 20250322 Mars.Hung編