FROM decidim/decidim:0.24.0.rc1

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

ENV RAILS_ENV=production
ENV PORT=3000

COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN bundle install
RUN bundle exec rake assets:precompile

ENTRYPOINT []
ENV RAILS_SERVE_STATIC_FILES=true
CMD bundle exec rails s
