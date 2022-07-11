# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.0.2'

DECIDIM_VERSION = { git: 'https://github.com/openpoke/decidim', branch: 'election-temp-fixes' }

gem 'decidim', DECIDIM_VERSION
# gem "decidim-conferences", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
gem 'decidim-elections', DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
# gem "decidim-templates", DECIDIM_VERSION

# gem "webpacker", "6.0.0.rc.5"

gem 'puma'
gem 'webpush'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'decidim-dev', DECIDIM_VERSION
  gem 'faker', '~> 2.14'
  gem 'letter_opener_web', '~> 1.4.0'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :production do
  gem 'aws-sdk-s3', require: false
  gem 'lograge'
  gem 'sendgrid-ruby'
  gem 'sentry-rails'
  gem 'sentry-ruby'
  gem 'sidekiq'
end
