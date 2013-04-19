module Reviewed
  class Client
    attr_accessor :api_key, :api_version, :request_params

    DEFAULT_BASE_URI = "https://the-guide-staging.herokuapp.com/api/v1"

    def initialize(opts={})
      @api_key = opts[:api_key] || ENV['REVIEWED_API_KEY']
      @request_params = opts[:request_params] || {}
    end

    def configure
      yield self
      self
    end

    def base_uri
      configatron.api.url || DEFAULT_BASE_URI
    end

    # Perform an HTTP GET request
    def get(path, params={})
      perform(:get, path, params)
    end

    # Perform an HTTP PUT request
    def put(path, params={})
      perform(:put, path, params)
    end

    # Perform an HTTP DELETE request
    def post(path, params={})
      perform(:post, path, params)
    end

    # Perform an HTTP DELETE request
    def delete(path, params={})
      perform(:delete, path, params)
    end

    def resource(name)
      klass_string = "Reviewed::#{name.to_s.singularize.classify}"
      klass_string.constantize rescue name
    end

    def method_missing(method, *args, &block)
      Reviewed::Request.new(resource: resource(method), client: self)
    end

    def connection
      @connection ||= ::Faraday.new(url: base_uri) do |faraday|
        faraday.response :mashify
        faraday.response :errors
        faraday.response :json
        faraday.request  :api_key
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end

    private

    def perform(method, path, params={})
      begin
        res = self.connection.send(method.to_sym, path, params) do |request|
          request.params.merge!(self.request_params)
          request.headers['X-Reviewed-Authorization'] ||= self.api_key
        end
        raise Reviewed::ApiError.new(msg: "API connection returned redirect or error") if res.status > 204 and res.status != 404
        res
      rescue Faraday::Error::ClientError => e
        message = <<-EOS.gsub(/^[ ]*/, '')
          API Error. method: #{method} url: #{base_uri} path: #{path} params: #{params.to_s} api_key: #{self.api_key}
          Original exception message:
          #{e.message}
        EOS
        new_exception = Reviewed::ApiError.new(msg: message)
        new_exception.set_backtrace(e.backtrace) # TODO not seeing in Airbrake
        raise new_exception
      end
    end
  end
end
