module Reviewed
  class Client
    attr_accessor :request_params, :base_uri, :api_key

    DEFAULT_BASE_URI = "http://localhost:3000/api/v1"

    class << self
      attr_accessor :api_key, :api_base_uri, :api_version

      def configure
        yield self
        self
      end

    end

    def initialize(opts={})
      @base_uri = opts[:base_uri] || config_base_uri
      @api_key = opts[:api_key] || config_api_key
      @request_params = opts[:request_params] || {}
    end

    def config_base_uri
      self.class.api_base_uri || DEFAULT_BASE_URI
    end

    def config_api_key
      self.class.api_key || ENV['REVIEWED_API_KEY']
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

    # args are options passed to request object, for example in:
    # client.attachments(scope: 'article')
    # args = [{scope: 'article'}]
    def method_missing(method, *args, &block)
      opts = { client: self, resource: resource(method) }
      opts = opts.merge!(args[0]) if args[0]
      Reviewed::Request.new(opts)
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
        raise Reviewed::ApiError.new(msg: "API connection returned redirect or error: status=#{res.status}", http_status: res.status) if res.status > 204 and res.status != 404
        res
      rescue Errno::ETIMEDOUT, Faraday::Error::ClientError => e
        message = %Q!API Error. method: #{method} url: #{base_uri} path: #{path} params: #{params.to_s} api_key: #{self.api_key}!
        message << " Original exception message: #{e.message}"
        new_exception = Reviewed::ApiError.new(msg: message)
        new_exception.set_backtrace(e.backtrace) # TODO not seeing in Airbrake
        raise new_exception
      end
    end
  end
end
