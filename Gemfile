# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/codegram/decidim", branch: "staging" }

gem "decidim", DECIDIM_VERSION
gem "decidim-dev", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-verifications-dummy_census", git: "https://github.com/agustibr/decidim-verifications-dummy_census", branch: "master"

gem "ransack", "~> 2.1.1"

gem "uglifier", ">= 1.3.0"
gem "sprockets", "~> 3.7.2"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"

gem "faker", "~> 1.9.6"

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
