if Rails.application.secrets.sentry_enabled?
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.environment = if ENV["HEROKU_APP_NAME"].present?
                           ENV["HEROKU_APP_NAME"]
                         else
                           "main"
                         end

    config.breadcrumbs_logger = [:active_support_logger]

    # Performance
    config.traces_sampler = lambda do |context|
      true
    end
  end
end
