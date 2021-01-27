# decidim_staging

Citizen Participation and Open Government application.

This is the open-source repository for decidim_staging, based on [Decidim](https://github.com/decidim/decidim). This app is used to preview the latest `staging` branch of Codegram's Decidim [fork](https://github.com/codegram/decidim/tree/staging).

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Review Apps

This application uses Heroku Review Apps to check new features individually and in isolation. In order to create a Review App:

1. Go to the [Actions](https://github.com/codegram/decidim-staging/actions) tab
2. Select **Review app creator** and click on **Run workflow** button
3. Fill in the **Decidim branch name** with the name of your feature branch
4. Optional: add the Decidim issue number
5. Click **Run workflow** (This will trigger a deploy of a new Review App. You can check it in the Heroku dashboard. Also, when the deployment is finished, it will appear in the PR in this repo.)
6. When the feature is reviewed close the PR (DO NOT MERGE IT!)

## Updating the app
Using the "Review App creator" can give some problems with migrations. You can use the "App updater" workflow to update and existing Review App with the last changes from the Decidim branch. In order to do it:

1. Go to the [Actions](https://github.com/codegram/decidim-staging/actions) tab
2. Select **App updater** and click on **Run workflow** button
3. Fill in the **Decidim branch name** with the name of your feature branch
4. Click **Run workflow**

Also, there's an alternative: use `bin/decidim_upgrade` (check `master` branch if your branch doesn't have it). The downside is that it currently needs to be executed manually (clone the repo, checkout to your branch, run the command and commit&push the changes) but it won't give any problems with migrations.

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
