web: jemalloc.sh bundle exec passenger start -p ${PORT:-3000} --max-pool-size ${WEB_CONCURRENCY:-5} --min-instances ${WEB_CONCURRENCY:-5}
worker: jemalloc.sh bundle exec sidekiq -e ${RACK_ENV:-development} -C config/sidekiq.yml
release: bundle exec rake db:migrate
