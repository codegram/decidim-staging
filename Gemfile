# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/tremend-cofe/decidim", branch: "feat/send-notification-to-hidden-resource-authors" }

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-dev", DECIDIM_VERSION
gem "decidim-elections", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "ransack", "~> 2.1.1"

gem "sprockets", "~> 3.7.2"
gem "uglifier", ">= 1.3.0"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"

gem "faker", "~> 2.14"

gem "puma"

group :development, :test do
  gem "byebug", platform: :mri
end

group :development do
  gem "letter_opener_web", "~> 1.4.0"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end

group :production do
  gem "dalli"
  gem "fog-aws"
  gem "lograge"
  gem "newrelic_rpm"
  gem "scout_apm"
  gem "sendgrid-ruby"
  gem "sentry-raven"
end
