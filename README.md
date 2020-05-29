# decidim_staging

Citizen Participation and Open Government application.

This is the open-source repository for decidim_staging, based on [Decidim](https://github.com/decidim/decidim). This app is used to preview the latest `master` branch of Decidim.

## Updating the app
The app needs to be updated manually. Steps to update it:

1. `bundle update decidim decidim-initiatives decidim-dev decidim-conferences decidim-consultations decidim-elections`
1. `bundle exec rake decidim:upgrade && bundle exec rails db:migrate`
1. `git add --all && git commit -m "Update decidim to latest master"`
1. `git push origin master`

If you need to re-seed the database:

1. Install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
1. Wait until the app has been successfully deployed
1. `heroku pg:reset`
1. `heroku run rails db:migrate` (just in case)
1. `heroku run rails db:seed`

If you need to recreate the whole database (to remove or fix migrations):

1. `rm db/schema.rb`
1. `rm db/migrate/*`
1. `rbenv exec bundle exec rake db:reset`
1. `rbenv exec bundle exec rake decidim:upgrade`
1. `rbenv exec bundle exec rake db:migrate`
1. `heroku pg:reset -a decidim-staging`
1. Push your changes to the `decidim-staging` repository
1. Wait until the app has been successfully deployed
1. `heroku run rails db:seed -a decidim-staging`
