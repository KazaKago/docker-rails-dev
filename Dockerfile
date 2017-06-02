FROM ruby:latest
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /app
WORKDIR /app
ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install -j4
ADD . .