FROM ruby:latest

# Install Essential tools
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

# Install newest Node.js
RUN apt-get install -y npm
RUN npm cache clean
RUN npm install n -g
RUN n stable
RUN ln -sf /usr/local/bin/node /usr/bin/node

# Install Yarn
RUN apt-get install -y apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Uninstall old Nodejs & npm
RUN apt-get purge -y nodejs npm

# Setup Rails
RUN mkdir /app
WORKDIR /app
ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install -j4
ADD . .