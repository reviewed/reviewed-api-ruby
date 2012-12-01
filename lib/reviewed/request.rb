module Reviewed
  class Request
    include ::Reviewed::Utils

    attr_accessor :client, :resource

    def initialize(opts={})
      @resource = opts[:resource]
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
    def delete(path, params={})
      perform(:delete, path, params)
    end

    # Get request on resource#show
    def find(id, params={})
      object_from_response(:get, "#{resource.to_s}/#{id}", params)
    end

    # Get request on resource#index with query params
    def where(params={})
      collection_from_response(:get, resource.to_s, params)
    end

    # Convenience Method
    def all
      where({})
    end

    private

    def perform(method, path, params={})
      client.connection.send(method.to_sym, path, params) do |request|
        request.headers['X-Reviewed-Authorization'] ||= Reviewed.api_key
      end
    end
  end
end
