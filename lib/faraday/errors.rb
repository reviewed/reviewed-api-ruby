module Faraday
  class Errors < Faraday::Middleware

    def call(env)

      @app.call(env).on_complete do
        if env[:response].status == 404
          raise Reviewed::ResourceNotFound.new('Not Found')
        end
      end
    end
  end
end

Faraday.register_middleware :response, errors: Faraday::Errors
