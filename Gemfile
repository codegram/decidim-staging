# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", ref: "d901eefa691d8906ff8f78643e6e4cd80a94ec04" }

gem "decidim-core", DECIDIM_VERSION
gem "decidim-admin", DECIDIM_VERSION
gem "decidim-api", DECIDIM_VERSION
gem "decidim-comments", DECIDIM_VERSION
gem "decidim-forms", DECIDIM_VERSION
gem "decidim-proposals", DECIDIM_VERSION
gem "decidim-pages", DECIDIM_VERSION
gem "decidim-system", DECIDIM_VERSION
gem "decidim-verifications", DECIDIM_VERSION
gem "decidim-participatory_processes", DECIDIM_VERSION
#gem "decidim-conferences", DECIDIM_VERSION
#gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-elections", DECIDIM_VERSION
#gem "decidim-initiatives", DECIDIM_VERSION
#gem "decidim-templates", DECIDIM_VERSION

#gem "webpacker", "6.0.0.rc.5"

gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "puma"

group :development, :test do
  gem "byebug", platform: :mri
end

group :development do
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker", "~> 2.14"
  gem "letter_opener_web", "~> 1.4.0"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end

group :production do
  gem "fog-aws"
  gem "lograge"
  gem "sendgrid-ruby"
  gem "sentry-ruby"
  gem "sentry-rails"
end
