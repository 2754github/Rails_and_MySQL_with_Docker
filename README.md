# DockerでRails+MySQLの環境構築

### このリポジトリをクローンし、ディレクトリ移動
```bash
$ git clone https://github.com/2754github/Rails_and_MySQL_with_Docker.git
$ cd Rails_and_MySQL_with_Docker
```

### 「rails new」の後、ビルド
```bash
$ docker-compose run app rails new . --api --force --no-deps --database=mysql --skip-test --webpacker
```
※かなり時間かかる

```bash
$ docker-compose build
```
※かなり時間かかる

### config/database.yml編集
`rails new`で作成された`config/database.yml`を編集

```yaml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV.fetch("MYSQL_USERNAME", "root") %>
  password: <%= ENV.fetch("MYSQL_PASSWORD", "password") %>
  host: <%= ENV.fetch("MYSQL_HOST", "db") %>

development:
  <<: *default
  database: app_development

test:
  <<: *default
  database: app_test

production:
  <<: *default
  database: app_production
  username: app
  password: <%= ENV['APP_DATABASE_PASSWORD'] %>
```

### DB作成とコンテナ起動
```bash
$ docker-compose run app rake db:create
$ docker-compose up
```

### 例のページが見られるか確認
http://localhost:3000/ にアクセス

### エラー対処
```bash
ERROR: for db  Cannot start service db: Ports are not available: listen tcp 0.0.0.0:3306: bind: address already in use
```
※訳）ポートが既に使用されています。

解決方法

```bash
$ sudo lsof -i -P | grep "LISTEN"　# 使用中のポートを確認
$ kill -9 <プロセスID> # 該当するものを削除
```
