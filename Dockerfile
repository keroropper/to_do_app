FROM ruby:3.2.1

ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo
ENV APP_ROOT /myapp
#node.js,apt-transport-https,wgetをインストール
RUN apt-get update -qq && apt-get install -y nodejs npm \
&& npm install --global yarn
#chromeドライバーをインストール
RUN apt-get update && apt-get install -y unzip && \
    CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver && \
    chmod 755 ~/chromedriver && \
    mv ~/chromedriver /usr/bin/chromedriver && \
    sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable
#/var/cache/apt/archives にキャッシュされている全てのパッケージを削除
RUN apt-get clean 
# /var/cache/apt/list にキャッシュされている全てのパッケージリストを削除
RUN rm -rf /var/lib/apt/lists/*

WORKDIR $APP_ROOT
ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT
RUN \
    gem install bundler:2.4.8 && \ 
    bundle install && \
    rm -rf ~/.gem
ADD . $APP_ROOT

RUN yarn install --check-files
RUN bundle exec rails webpacker:compile

COPY ./entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
