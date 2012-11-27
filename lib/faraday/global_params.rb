module Faraday
  class GlobalParams < Faraday::Middleware

    def call(env)
      params = Reviewed.global_params

      if params && params.is_a?(Hash)
        path = env[:url].path
        query = env[:url].query || {}
        env[:url].query = Faraday::Utils.build_query(query.merge(params))
      end

      @app.call(env)
    end
  end
end

Faraday.register_middleware :request, global_params: Faraday::GlobalParams
