# Rails Starter Kit

https://docs.docker.com/compose/rails/  
ホストマシンへrubyをインストールせずDockerコンテナへRails + MySQL + WebPackの開発環境を構築する手順

## プロジェクト生成

1. プロジェクトを作成するフォルダに以下の5つのファイルを配置
- Dockerfile
- docker-compose.yml
- Gemfile
- Gemfile.lock
- Procfile

2. Railsプロジェクト作成
```bash
docker-compose run --rm web rails new . --force --database=mysql --webpack
```

3. WebPack変更監視サーバ(bin/webpack-dev-server)の自動立ち上げのためのGemfileにforemanを追加
```yml
gem 'foreman'
```

4. Gemfileを更新したのでBundle installを実行してGemfile.lockを更新
```bash
docker-compose run --rm web bundle install
```

5. WebPackerでインストールしたjsをインポートするためにapp/views/layouts/application.html.erbへ以下の記述をする
```xml
<%= javascript_pack_tag 'application' %>
```

6. config/database.ymlをDockerの設定値から取得するように変更
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

## コンテナ毎初期化

1. db:createを叩くためGemfile.lock固定後のイメージを構築
```bash
docker-compose build
```

2. DB初期化
```bash
docker-compose run --rm web rails db:create
```

3. yarnインストール（プロジェクト生成時は自動で--webpackオプションによりyarn installが走るので不要）
```bash
docker-compose run --rm web yarn install
```

## 立ち上げ

1. 起動
```bash
docker-compose up -d
open  http://localhost:3000
```

## その他各種操作

### Gemfileを変更した場合

1. Bundle installを実行してGemfile.lockを更新
```bash
docker-compose run --rm web bundle install
```

2. Gemfile.lock更新後のイメージを再構築&起動
```bash
docker-compose up -d
open  http://localhost:3000
```

### DBの中身を削除する場合

1. --volumesオプションを付与してコンテナを削除
```bash
docker-compose down --volumes
```

### Javascriptライブラリを追加したい場合

1. yarn経由でインストールする
```bash
docker-compose run --rm web yarn add moment
```

2. app/javascript/packs/application.jsで使用するライブラリをインポートする
```yml
import moment from "moment";
```
