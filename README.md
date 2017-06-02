# Compose and Rails

https://docs.docker.com/compose/rails/  
ホストマシンへrubyをインストールせずにrails newからdeployまでを行う手順

## 必要物
- Docckerfile
- docker-compose.yml
- Gemfile
- Gemfile.lock

## 手順

### 既存プロジェクトがある場合

1. 既存プロジェクトのルート階層に以下の2つのファイルを配置
- Docckerfile
- docker-compose.yml

3. DB初期化
```bash
docker-compose run --rm web rake db:create
```

4. 起動
```bash
docker-compose up -d
open  http://localhost:3000
```

### 新規プロジェクトから作成する場合

1. プロジェクトを作成するフォルダに以下の4つのファイルを配置
- Docckerfile
- docker-compose.yml
- Gemfile
- Gemfile.lock

2. Railsプロジェクト作成
```bash
docker-compose run --rm web rails new . --force --database=mysql --skip-bundle
```

3. db:createを叩くためGemfile.lock更新後のイメージを再構築
```bash
docker-compose build
```

4. config/database.ymlをDockerの設定値から取得するように変更
```yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV.fetch('DATABASE_USER') { 'root' } %>
  password: <%= ENV.fetch('DATABASE_PASSWORD') { 'password' } %>
  host: <%= ENV.fetch('DATABASE_HOST') { 'localhost' } %>

development:
  <<: *default
  database: app_development

test:
  <<: *default
  database: app_test

production:
  <<: *default
  database: app_production
```

5. DB初期化
```bash
docker-compose run --rm web rake db:create
```

6. 起動
```bash
docker-compose up -d
open  http://localhost:3000
```

### Gemfileを変更した場合

1. Bundle installを実行してGemfile.lockを更新
```bash
docker-compose run --rm web bundle install
```

2. イメージを再構築&起動
```bash
docker-compose up -d
open  http://localhost:3000
```
