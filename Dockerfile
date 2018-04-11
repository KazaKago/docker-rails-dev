FROM ruby:latest

# Install Node.js
# https://nodejs.org/en/download/package-manager/
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs

# Install Yarn
# https://yarnpkg.com/lang/en/docs/install/
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Setup Rails
# https://docs.docker.com/compose/rails/
RUN mkdir /app
WORKDIR /app
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY . .
