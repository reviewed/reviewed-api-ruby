module Reviewed
  class Request
    attr_accessor :client, :resource

    def initialize(opts={})
      @cache_string = []
      @resource = opts[:resource]
      @scope = opts[:scope]
      @client = opts[:client] || Reviewed::Client.new
    end
    
    def query_string
      unless @cache_string.blank?
        "?#{@cache_string.join( "&" )}"
      else
        ""
      end
    end

    def path
      if @resource.respond_to? :to_path
        @resource.to_path(@scope) + query_string
      else
        @resource.to_s + query_string
      end
    end

    def skip_cache
      @cache_string << "skip-cache=true"
      self
    end

    def reset_cache
      @cache_string << "reset-cache=true"
      self
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

    def cached?
      cache_store.contains? path
    end

    def uncached?
      !cached?
    end

    def cache_store
      @cache_store ||= Reviewed::Cachetacular.new
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
