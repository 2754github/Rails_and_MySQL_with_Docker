# DockerでRails+MySQLの環境構築

### 1
```bash
$ docker-compose run app rails new . --force --no-deps --database=mysql --skip-test --webpacker
$ docker-compose build
```

### 2
`rails new`で作成された`config/database.yml`を編集

```yml:config/database.yml

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

### 3
```bash
$ docker-compose run app rake db:create
$ docker-compose up
```

### 4
http://localhost:3000/ にアクセス
