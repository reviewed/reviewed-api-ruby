module Reviewed
  class Client
    include ::Reviewed::Configurable

    attr_accessor :api_key, :base_uri, :api_version

    def initialize
      Reviewed::Configurable.options.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end
    end

    # Perform an HTTP DELETE request
    def delete(path, params={})
      request(:delete, path, params)
    end

    # Perform an HTTP GET request
    def get(path, params={})
      request(:get, path, params)
    end

    # Perform an HTTP POST request
    def post(path, params={})
      request(:post, path, params)
    end

    # Perform an HTTP PUT request
    def put(path, params={})
      request(:put, path, params)
    end

    def url
      [base_uri, api_version].join('/')
    end

    private

    def request(method, path, params={})
      verify_key!

      connection.send(method.to_sym, path, params) do |request|
        request.headers['X-Reviewed-Authorization'] ||= Reviewed.api_key
      end
    end

    def connection
      @connection ||= ::Faraday.new(url: url) do |faraday|
        faraday.response :mashify
        faraday.response :json
        faraday.request  :session_params if defined?(Rails)
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
