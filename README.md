# Readmine Pod

これは個人的に Redmine を Podman の Pod で構築するために作ったメモです。  
利用において私は責任を持ちません。
(というか試行錯誤の反映漏れがあって動かないかもしれない...)

## 使い方

この Pod には２つのコンテナが含まれます。

- Redmine 
- Postgresql

※ すべての作業は root ユーザーで進めます。

### コンテナイメージのDL
以下のイメージを利用しておりますので、予めダウンロードしておきます。

- docker.io/library/redmine:5.1.3
- docker.io/library/postgres:16.4-bullseye

```shell
podman pull docker.io/library/redmine:5.1.3
podman pull docker.io/library/postgres:16.4-bullseye
```

### redmine-pod.yml の書き換え

環境変数などは自分で書き換えましょう。(言いたいのはそれだけ)

### 初期化

以下のスクリプトを実行します。

```shell
git clone https://github.com/kushimoto/redmine-pod.git
cd redmine-pod
bash init.sh
```

### 登録

以下のコマンドを実行します

```shell
/usr/libexec/podman/quadlet /usr/share/containers/systemd/redmine-pod.kube 
systemctl daemon-reload
systemctl start redmine-pod.service
```

### ログイン

http://{サーバーのIPアドレス}}:8002 にアクセスして admin/admin でログインできます。

selinux が有効な場合は下記コマンドが必要かもしれない。(ファイアウォールはまだ検索しやすいので書かないぞ :heart: )

```shell
semanage port -a -t http_port_t -p tcp 8002
```

### メモ欄

- Podを作る

```shell
podman pod create --name Readmine -p 8002:3000 --network slirp4netns
```

- コンテナを作る

```shell
podman run -d --name db --pod Redmine  \
  -e POSTGRES_DB=redmine \
  -e POSTGRES_USER=redmine \
  -e POSTGRES_PASSWORD=redmine \
  -v /opt/redmine/data/db:/var/lib/postgresql/data:Z \
  docker.io/library/postgres:16.4-bullseye

podman run -d --name app --pod Redmine  \
  -e REDMINE_DB_POSTGRES=redmine \
  -e REDMINE_DB_DATABASE=redmine \
  -e REDMINE_DB_USERNAME=redmine \
  -e REDMINE_DB_PASSWORD=redmine \
  -e REDMINE_SECRET_KEY_BASE=secretkey \
  -e REDMINE_DB_PORT=5432 \
  -v /opt/redmine/data/app:/usr/src/redmine/files:Z \
  docker.io/library/redmine:5.1.3
```

- YAMLを吐き出す

```shell
podman generate kube Redmine
```
