# Starts with a clean ruby image from Debian (slim)
FROM ruby:2.7.2

# Installs system dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  graphviz \
  imagemagick \
  libicu-dev \
  libpq-dev \
  nodejs \
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
ADD Gemfile Gemfile.lock /app/
RUN gem install bundler
RUN bundle install

# Copy all the code to /app
ADD . /app

RUN bundle exec rake assets:precompile