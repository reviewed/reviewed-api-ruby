module Faraday
  class RequestParams < Faraday::Middleware

    def call(env)
      params = env[:request_params]

      if params && params.is_a?(Hash)
        path = env[:url].path

        query = ::Rack::Utils.parse_nested_query(env[:url].query) || {}
        query = Faraday::Utils.build_query(query.merge(params))

        env[:url].query = query unless query.blank?
      end

      @app.call(env)
    end
  end
end

Faraday.register_middleware :request, request_params: Faraday::RequestParams
