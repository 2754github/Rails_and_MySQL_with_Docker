# ベースイメージはなるべく新しいものを
FROM ruby:2.6

# コンテナのlocaleの設定
ENV LANG C.UTF-8

# 「apt-get install」の際にユーザーと対話してくるものがあった場合に困るので、予めセットしておく。
ENV DEBIAN_FRONTEND noninteractive

# 基本的なものをインストール
# -y: 対話全てにyesで答える
# -qq: エラーのみ表示
RUN apt-get update -qq && \
  apt-get install -y build-essential tree vim less dnsutils net-tools exiftool && \
  apt-get install -y --no-install-recommends apt-utils

# node.jsとyarnをインストール
# @see node https://askubuntu.com/questions/786272/why-does-installing-node-6-x-on-ubuntu-16-04-actually-install-node-4-2-6
# @see yarn https://yarnpkg.com/en/docs/install#linux-tab
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && \
  apt-get install -y nodejs yarn

# mysql-clientをインストール（mysql-clientはmariadb-clientに統合された）
RUN apt-get install -qq mariadb-client


ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . $APP_HOME

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
