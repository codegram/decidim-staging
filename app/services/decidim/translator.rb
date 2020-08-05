# frozen_string_literal: true

require "savon"
require "nokogiri"
require "httparty"

module Decidim
  # This translator recieves the data for translation
  # and makes a post call to the translation service.
  class Translator
    attr_reader :text, :source_locale, :target_locale, :resource, :field_name

    def initialize(resource, field_name, text, target_locale, source_locale)
      @resource = resource
      @field_name = field_name
      @text = text
      @source_locale = source_locale
      @target_locale = target_locale
      @custom_id = "#{resource.to_sgid}__#{field_name}"
    end

    def build_translation_request
      body = Nokogiri::XML::Builder.new  do |xml|
        xml.send(:"soapenv:Envelope",  'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/','xmlns:cef' => 'http://cef.dgt.ec.europa.eu'  )  do |env|
          xml.parent.namespace = xml.parent.namespace_definitions.first
          env.send(:"soapenv:Header")
          env.send(:"soapenv:Body") do |body|
            body.send(:"cef:translate") do |arg0|
              arg0.send(:"arg0") do |caller|

                caller.parent.namespace = xml.parent.namespace_definitions.first
                caller.send(:"external-reference", @custom_id)
                caller.send(:"caller-information") do
                  caller.send(:"username", "Decidim")
                  caller.send(:"application", Rails.application.secrets.etranslation_app)
                end

                body.send(:"text-to-translate", @text)
                body.send(:"source-language",  @source_locale)
                body.send(:"requesterCallback", Rails.application.secrets.etranslation_callback)
                body.send(:"target-languages") do |target|
                  target.send(:"target-language", @target_locale)
                end

                body.send(:"destinations") do |target|
                  target.send(:"http-destination", Rails.application.secrets.etranslation_callback)
                end
              end
            end
          end
        end
      end
      return body.to_xml
    end

    def translate
      body = build_translation_request
      client = Savon.client do wsdl "https://webgate.ec.europa.eu/etranslation/si/WSEndpointHandlerService?WSDL" end
      result = client.call(:translate, :xml=> body)

      hres = result.to_hash
      requestId = hres[:translate_response][:return]

      if requestId.to_i > 0
        "bazzinga"
      end
    end
  end
end

