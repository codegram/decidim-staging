web: jemalloc.sh bundle exec puma -C config/puma.rb
worker: jemalloc.sh bundle exec sidekiq -e ${RACK_ENV:-development} -C config/sidekiq.yml
release: bundle exec rake db:migrate
