module Reviewed
  class Request
    attr_accessor :client, :resource

    def initialize(opts={})
      @resource = opts[:resource]
      @scope = opts[:scope]
      @client = opts[:client] || Reviewed::Client.new
    end

    def path
      if @resource.respond_to? :to_path
        @resource.to_path(@scope)
      else
        @resource.to_s
      end
    end

    # Get request on resource#show
    def find(id, params={})
      url_path = [path, CGI::escape(id.to_s)].join('/')
      object_from_response(:get, url_path, params)
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
