# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# You can remove the 'faker' gem if you don't want Decidim seeds.
if ENV["HEROKU_APP_NAME"].present?
  raise "Missing \"DECIDIM_HOST\" env variable." unless ENV["DECIDIM_HOST"]
  ENV["SEED"] = "true"
end
Decidim.seed!
Decidim::ActionLog.delete_all
PaperTrail::Version.delete_all
Decidim::Gamification::BadgeScore.delete_all
