module Reviewed
  class Client
    attr_accessor :api_key, :base_uri, :api_version, :request_params

    BASE_URI = "http://localhost:3000/api/v1"

    def initialize(opts={})
      @api_key = opts[:api_key] || ENV['REVIEWED_API_KEY']
      @base_uri = opts[:base_uri] || BASE_URI
      @request_params = opts[:request_params] || {}
    end

    def configure
      yield self
      self
    end

    def resource(name)
      klass_string = "Reviewed::#{name.to_s.singularize.classify}"
      klass_string.constantize rescue name
    end

    def method_missing(method, *args, &block)
      Reviewed::Request.new(resource: resource(method), client: self)
    end

    def connection
      @connection ||= ::Faraday.new(url: BASE_URI) do |faraday|
        faraday.response :mashify
        faraday.response :json
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
