module Reviewed
  class Request
    attr_accessor :client, :resource
    attr_reader :path

    def initialize(opts={})
      if opts[:resource].kind_of?(Class)
        @resource = opts[:resource]
        @path = opts[:path] || @resource.path
      else
        @path = opts[:resource].to_s
      end

      @client = opts[:client] || Reviewed::Client.new
    end

    # Get request on resource#show
    def find(id, params={})
      url_path = [path, CGI::escape(id.to_s)]
      object_from_response(:get, url_path.join('/'), params)
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
      response = client.send(method, url, params)
      resource.new(response.body)
    end

    def collection_from_response(method, url, params={})
      response = client.send(method, url, params)
      Reviewed::Collection.new(client, resource, response, params)
    end
  end
end
