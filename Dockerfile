# FROM ruby:3.1.2
# ENV RAILS_ENV=production

# ENV TZ Asia/Tokyo
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get install -y vim

# # Install yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#   && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#   && apt-get update \
#   && apt-get install -y yarn

# # 作業ディレクトリを指定
# WORKDIR /menu_vid

# # ホストのGemfileとGemfile.lockをコンテナにコピー
# COPY Gemfile Gemfile.lock /menu_vid/

# # bundle installを実行
# RUN bundle install

# # ホストのカレントディレクトリをコンテナにコピー
# COPY . /menu_vid

# # entrypoint.shをコンテナ内の/usr/binにコピーし、実行権限を与える
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh

# # ENTRYPOINTとCMDを統合
# ENTRYPOINT ["entrypoint.sh"]
# CMD ["rails", "server", "-b", "0.0.0.0"]

FROM ruby:3.1.2

RUN apt update -qq
RUN mkdir /menu_vid
WORKDIR /menu_vid
COPY Gemfile /menu_vid/Gemfile
COPY Gemfile.lock /menu_vid/Gemfile.lock
RUN bundle install
COPY . /menu_vid

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
