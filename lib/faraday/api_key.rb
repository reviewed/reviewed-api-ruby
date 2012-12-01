module Faraday
  class ApiKey < Faraday::Middleware

    def call(env)
      unless env.request.headers['X-Reviewed-Authorization']
        raise ConfigurationError.new("Please set the API key for your Reviewed::Client instance before making a request")
      end
    end
  end
end

Faraday.register_middleware :request, api_key: Faraday::ApiKey
