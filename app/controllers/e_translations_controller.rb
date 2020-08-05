# frozen_string_literal: true

class ETranslationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_same_origin_request

  def callback
    translated_text = request.raw_post
    target_locale = params["target-language"].downcase
    external_reference = params["external-reference"]

    global_id, field_name = external_reference.split("__")

    resource = GlobalID::Locator.locate(global_id)

    Rails.logger.info "=================================="
    Rails.logger.info "Translated text: #{translated_text}"
    Rails.logger.info "Target locale: #{target_locale}"
    Rails.logger.info "Field name: #{field_name}"
    Rails.logger.info "Resource: #{resource.class.name} #{resource&.id}"
    Rails.logger.info "=================================="

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

