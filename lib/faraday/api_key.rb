module Faraday
  class ApiKey < Faraday::Middleware

    def call(env)
      unless env[:request_headers]['X-Reviewed-Authorization']
        raise ::Reviewed::ConfigurationError.new(msg: "Please set the API key for your Reviewed::Client instance before making a request")
      end

      @app.call(env)
    end
  end
end

Faraday.register_middleware :request, api_key: Faraday::ApiKey
