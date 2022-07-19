# Starts with a clean ruby image from Debian (slim)
FROM ruby:3.0.2

# Installs system dependencies
ENV DEBIAN_FRONTEND noninteractive
ENV DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname
RUN apt-get update -qq && apt-get install -y && apt-get -y install gnupg2 && \
  curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn \
  build-essential \
  graphviz \
  imagemagick \
  libicu-dev \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# Sets workdir as /app
RUN mkdir /app
WORKDIR /app

# Installs bundler dependencies
ENV \
  BUNDLE_BIN=/usr/local/bundle/bin \
  BUNDLE_JOBS=10 \
  BUNDLE_PATH=/usr/local/bundle \
  BUNDLE_RETRY=3 \
  GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Copy Gemfile and install bundler dependencies
COPY ./package-lock.json /app/package-lock.json
COPY ./package.json /app/package.json
COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock

RUN gem install bundler
RUN bundle config set force_ruby_platform true
RUN bundle install
RUN npm ci

ADD . /app

RUN RAILS_ENV=production \
    SECRET_KEY_BASE=dummy \
    RAILS_MASTER_KEY=dummy \
    bundle exec rails assets:precompile