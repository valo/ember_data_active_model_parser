require "ember_data_active_model_parser/version"
require "ember_data_active_model_parser/embed_associations"
require "faraday"

module EmberDataActiveModelParser
  class Middleware < Faraday::Response::Middleware
    def parse(body)
      json = MultiJson.load(body, symbolize_keys: true)

      EmbedAssociations.new(json).call
    end

    def on_complete(env)
      Rails.logger.info parse(env[:body]).inspect
      env[:body] = {
        data: parse(env[:body])
      }
    end
  end
end
