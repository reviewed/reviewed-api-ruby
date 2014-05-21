module Faraday
  class Errors < Faraday::Middleware

    def call(env)
      @app.call(env).on_complete do
        if env[:response].status == 404
          raise Reviewed::ResourceNotFound.new(msg: 'Not Found', url: env[:url])
        end
      end
    end
  end
end

Faraday::Response.register_middleware(errors: Faraday::Errors)
