if ENV["HEROKU_APP_NAME"].present?
  ENV["DECIDIM_HOST"] ||= "#{ENV["HEROKU_APP_NAME"]}.herokuapp.com"
  ENV["SEED"] = "true"
end
if Decidim::Organization.count == 0
  Decidim.seed!
end
