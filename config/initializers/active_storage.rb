# frozen_string_literal: true

if ENV["HEROKU_APP_NAME"].present?
  ActiveSupport.on_load(:active_storage_blob) do
    def key
      self[:key] ||= "#{Decidim.base_uploads_path}#{self.class.generate_unique_secure_token}"
    end
  end
end