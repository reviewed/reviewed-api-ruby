module Reviewed
  class Request
    attr_accessor :client, :resource
    attr_reader :path

    def initialize(opts={})
      if opts[:resource].kind_of?(Class)
        @resource = opts[:resource]
        @path = @resource.path
      else
        @path = opts[:resource].to_s
      end

      @client = opts[:client] || Reviewed::Client.new
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

    # Get request on resource#show
    def find(id, params={})
      object_from_response(:get, "#{path}/#{id}", params)
    end

    # Get request on resource#index with query params
    def where(params={})
      collection_from_response(:get, path, params)
    end

    # Convenience Method
    def all
      where({})
    end

    def object_from_response(method, url, params={})
      response = self.send(method, url, params)
      resource.new(response.body)
    end

    def collection_from_response(method, url, params={})
      response = self.send(method, url, params)
      Reviewed::Collection.new(client, resource, response, params)
    end

    private

    def perform(method, path, params={})
      client.connection.send(method.to_sym, path, params) do |request|
        request.params.merge!(client.request_params)
        request.headers['X-Reviewed-Authorization'] ||= client.api_key
      end
    end
  end
end
