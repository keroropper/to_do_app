FROM ruby:3.2
#node.js,apt-transport-https,wgetをインストール
RUN apt-get update -qq && apt-get install -y nodejs npm \
&& npm install --global yarn
#/var/cache/apt/archives にキャッシュされている全てのパッケージを削除
RUN apt-get clean 
# /var/cache/apt/list にキャッシュされている全てのパッケージリストを削除
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

RUN yarn install --check-files
RUN bundle exec rails webpacker:compile

COPY ./entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
