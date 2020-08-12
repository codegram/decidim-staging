# decidim_staging

Citizen Participation and Open Government application.

This is the open-source repository for decidim_staging, based on [Decidim](https://github.com/decidim/decidim). This app is used to preview the latest `staging` branch of Codegram's Decidim [fork](https://github.com/codegram/decidim/tree/staging).

## Review Apps

This application uses Heroku Review Apps to check new features individually and in isolation. In order to create a Review App:

1. `git checkout master`
1. `git pull origin master`
1. Move to your own branch: `git checkout -b my-branch-name`
1. Edit the `Gemfile` so that the `decidim` dependencies point to the branch you want to test out
1. `bundle update decidim decidim-initiatives decidim-dev decidim-conferences decidim-consultations decidim-elections`
1. `bundle exec rake decidim:upgrade db:migrate`
1. `git add --all && git commit -m "Update decidim"`
1. `git push origin my-branch-name`
1. Open a PR from `my-branch` to `master`. This will trigger a deploy of a new Review App. You can check it in the Heroku dashboard. Also, when the deployment is finished, it will appear in the PR in this repo.

## Updating the app
The app needs to be updated manually. Steps to update it:

1. Move to your own branch: `git branch -b my-branch-name`
1. `bundle update decidim decidim-initiatives decidim-dev decidim-conferences decidim-consultations decidim-elections`
1. `bundle exec rake decidim:upgrade db:migrate`
1. `git add --all && git commit -m "Update decidim"`
1. `git push origin my-branch-name`

Remember to create a PR for your branch so that a Review App is created automatically.

## Reseeding the DB

If you need to re-seed the database:

1. Install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
1. Wait until the app has been successfully deployed
1. `heroku pg:reset --app decidim-staging-pr-<your PR ID>`
1. `heroku run rails db:migrate --app decidim-staging-pr-<your PR ID>`
1. `heroku run rails db:seed --app decidim-staging-pr-<your PR ID>`

## Recreating the whole DB

If you need to recreate the whole database (to remove or fix migrations):

1. `rm db/schema.rb`
1. `rm db/migrate/*`
1. `rbenv exec bundle exec rake db:reset`
1. `rbenv exec bundle exec rake decidim:upgrade`
1. `rbenv exec bundle exec rake db:migrate`
1. `heroku pg:reset -a decidim-staging-pr-<your PR ID>`
1. Push your changes to the `decidim-staging` repository
1. Wait until the app has been successfully deployed
1. `heroku run rails db:seed -a decidim-staging-pr-<your PR ID>`
