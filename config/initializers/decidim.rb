# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = 'Decidim Codegram Staging'
  config.mailer_sender = ENV["SMTP_FROM_EMAIL"]

  # Change these lines to set your preferred locales
  config.default_locale = :en
  config.available_locales = %i[en ca es]

  # Geocoder configuration
  # config.maps = {
  #   provider: :here,
  #   api_key: Rails.application.secrets.maps[:api_key],
  #   static: { url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview" }
  # }
  # config.geocoder = {
  #   timeout: 5,
  #   units: :km
  # }

  # Custom resource reference generator method
  # config.reference_generator = lambda do |resource, component|
  #   # Implement your custom method to generate resources references
  #   "1234-#{resource.id}"
  # end

  # Currency unit
  # config.currency_unit = "€"

  # The number of reports which an object can receive before hiding it
  # config.max_reports_before_hiding = 3

  # Custom HTML Header snippets
  #
  # The most common use is to integrate third-party services that require some
  # extra JavaScript or CSS. Also, you can use it to add extra meta tags to the
  # HTML. Note that this will only be rendered in public pages, not in the admin
  # section.
  #
  # Before enabling this you should ensure that any tracking that might be done
  # is in accordance with the rules and regulations that apply to your
  # environment and usage scenarios. This component also comes with the risk
  # that an organization's administrator injects malicious scripts to spy on or
  # take over user accounts.
  #
  config.enable_html_header_snippets = false

  # SMS gateway configuration
  #
  # If you want to verify your users by sending a verification code via
  # SMS you need to provide a SMS gateway service class.
  #
  # An example class would be something like:
  #
  # class MySMSGatewayService
  #   attr_reader :mobile_phone_number, :code
  #
  #   def initialize(mobile_phone_number, code)
  #     @mobile_phone_number = mobile_phone_number
  #     @code = code
  #   end
  #
  #   def deliver_code
  #     # Actual code to deliver the code
  #     true
  #   end
  # end
  #
  config.sms_gateway_service = 'Decidim::Verifications::Sms::ExampleGateway'

  # Timestamp service configuration
  #
  # Provide a class to generate a timestamp for a document. The instances of
  # this class are initialized with a hash containing the :document key with
  # the document to be timestamped as value. The istances respond to a
  # timestamp public method with the timestamp
  #
  # An example class would be something like:
  #
  # class MyTimestampService
  #   attr_accessor :document
  #
  #   def initialize(args = {})
  #     @document = args.fetch(:document)
  #   end
  #
  #   def timestamp
  #     # Code to generate timestamp
  #     "My timestamp"
  #   end
  # end
  #
  config.timestamp_service = 'Decidim::Initiatives::DummyTimestamp'

  # PDF signature service configuration
  #
  # Provide a class to process a pdf and return the document including a
  # digital signature. The instances of this class are initialized with a hash
  # containing the :pdf key with the pdf file content as value. The instances
  # respond to a signed_pdf method containing the pdf with the signature
  #
  # An example class would be something like:
  #
  # class MyPDFSignatureService
  #   attr_accessor :pdf
  #
  #   def initialize(args = {})
  #     @pdf = args.fetch(:pdf)
  #   end
  #
  #   def signed_pdf
  #     # Code to return the pdf signed
  #   end
  # end
  #
  config.pdf_signature_service = 'Decidim::Initiatives::PdfSignatureExample'

  # Etherpad configuration
  #
  # Only needed if you want to have Etherpad integration with Decidim. See
  # Decidim docs at docs/services/etherpad.md in order to set it up.
  #
  config.etherpad = {
    server: Rails.application.secrets.etherpad[:server],
    api_key: Rails.application.secrets.etherpad[:api_key],
    api_version: Rails.application.secrets.etherpad[:api_version]
  }

  config.base_uploads_path = ENV['HEROKU_APP_NAME'] + '/' if ENV['HEROKU_APP_NAME'].present?
end


if Decidim.module_installed? :elections
  Decidim::Elections.configure do |config|
    config.setup_minimum_hours_before_start = Rails.application.secrets.dig(:elections, :setup_minimum_hours_before_start)
    config.start_vote_maximum_hours_before_start = Rails.application.secrets.dig(:elections, :start_vote_maximum_hours_before_start)
    config.voter_token_expiration_minutes = Rails.application.secrets.dig(:elections, :voter_token_expiration_minutes).presence || 120
  end

  Decidim::Votings.configure do |config|
    config.check_census_max_requests = Rails.application.secrets.dig(:elections, :votings, :check_census_max_requests).presence || 5
    config.throttling_period = Rails.application.secrets.dig(:elections, :votings, :throttling_period).to_i.minutes
  end

  Decidim::Votings::Census.configure do |config|
    config.census_access_codes_export_expiry_time = Rails.application.secrets.dig(:elections, :votings, :census, :access_codes_export_expiry_time).to_i.days
  end
end

Decidim.register_assets_path File.expand_path('app/packs', Rails.application.root)

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
