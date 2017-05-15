# 必要物
- Docckerfile.development
- docker-compose.yml
- Gemfile
- Gemfile.lock

# 手順(without database)

1. Railsプロジェクト作成
```bash
docker-compose run --rm web rails new . --force --skip-bundle
```

2. 起動
```bash
docker-compose up -d
open  http://localhost:3000
```

# 手順(with postgres)

1. Railsプロジェクト作成
```bash
docker-compose run --rm web rails new . --force --database=postgresql --skip-bundle
```

2. db:createを叩くためGemfile.lock更新後のイメージを再構築
```bash
docker-compose build
```

3. config/database.ymlをDockerの設定値から取得するように変更
```yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV.fetch('DATABASE_USER') { 'root' } %>
  password: <%= ENV.fetch('DATABASE_PASSWORD') { 'password' } %>
  host: <%= ENV.fetch('DATABASE_HOST') { 'localhost' } %>
  port: <%= ENV.fetch('DATABASE_PORT') { 5432 } %>

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

4. DB初期化
```bash
docker-compose run --rm web rails db:create
```

5. 起動
```bash
docker-compose up -d
open  http://localhost:3000
```

# Gemを追加・変更した場合

1. Bundle installを実行してGemfile.lockを更新
```bash
docker-compose run --rm web bundle install
```

2. イメージを再構築&起動
```bash
docker-compose up -d
```
