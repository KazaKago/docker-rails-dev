FROM ruby:latest

# Install Node.js
# https://nodejs.org/en/download/package-manager/
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs

# Install Yarn
# https://yarnpkg.com/lang/en/docs/install/
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

# Setup Rails
# https://docs.docker.com/compose/rails/
RUN mkdir /app
WORKDIR /app
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]