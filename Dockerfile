# Render（無料プラン）で公開するためのイメージ
FROM ruby:2.7.6

# CoffeeScript・Uglifier の実行に Node が要る（Debian 11 の apt 版は取得できないため公式イメージから借りる）
COPY --from=node:18-bullseye-slim /usr/local/bin/node /usr/local/bin/node
RUN gem install bundler -v 2.1.4 --no-document

ENV RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=1 \
    RAILS_LOG_TO_STDOUT=1 \
    BUNDLE_WITHOUT="development:test"

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle _2.1.4_ install --jobs 4
COPY . .
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# 無料プランは止まるたびにファイルが消えるので、起動のたびにDBを作り直して初期データを入れる
# SECRET_KEY_BASE が未設定なら起動ごとに作る（データも毎回消えるので、ログイン状態が切れても困らない）
CMD ["bash", "-c", "rm -f tmp/pids/server.pid; export SECRET_KEY_BASE=${SECRET_KEY_BASE:-$(openssl rand -hex 64)}; DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:schema:load db:seed && bundle exec puma -C config/puma.rb"]
