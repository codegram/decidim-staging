# frozen_string_literal: true

class ETranslationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_same_origin_request

  # protect_from_forgery prepend: true, with: :exception

  def callback
    translated_text = request.raw_post
    target_locale = params["target-language"]
    external_reference = params["external-reference"]

    sgid, field_name = external_reference.split("__")

    resource = GlobalID::Locator.locate(sgid)

    Rails.logger.log "=================================="
    Rails.logger.log "Translated value: ", translated_value
    Rails.logger.log "Target locale: ", target_locale
    Rails.logger.log "Field name: ", field_name
    Rails.logger.log "Resource: ", resource.class.name, resource&.id
    Rails.logger.log "=================================="

    if resource.present?
      Decidim::MachineTranslationSaveJob.perform_later(
        resource,
        field_name,
        target_locale,
        translated_text
      )
    end
  end
end

