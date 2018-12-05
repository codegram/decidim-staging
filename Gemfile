# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", branch: "remove-current-feature" }

gem "decidim", DECIDIM_VERSION
gem "decidim-dev", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "ransack", git: 'https://github.com/activerecord-hackery/ransack', branch: '8daa87a0389d380f7c9fd7ea9cb5bda634d5dc7d'

gem "uglifier", ">= 1.3.0"

gem "faker", "~> 1.8.4"

gem "puma"

group :development, :test do
  gem "byebug", platform: :mri
end

group :development do
  gem "letter_opener_web", "~> 1.3.0"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end

group :production do
  gem "fog-aws"
  gem "dalli"
  gem "sendgrid-ruby"
  gem "newrelic_rpm"
  gem "lograge"
  gem "sentry-raven"
  gem "sidekiq"
  gem "scout_apm"
end
