module Reviewed
  class Request
    attr_accessor :client, :resource

    def initialize(opts={})
      @resource = opts[:resource]
      @scope = opts[:scope]
      @client = opts[:client] || Reviewed::Client.new
      @skip_cache = false
      @reset_cache = false
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
      !uncached?
    end

    def uncached?
      skip_cache? || reset_cache?
    end

    def with_no_cache
      @skip_cache = true
      self
    end

    def with_new_cache
      @reset_cache = true
      self
    end

    def object_from_response(method, url, params={})
      response = client.send(method, url, params.merge(cache_control_params))
      resource.new(response.body, client)
    end

    def collection_from_response(method, url, params={})
      response = client.send(method, url, params.merge(cache_control_params))
      Reviewed::Collection.new(client, resource, response, params)
    end

    def cache_control_params
      params = {}
      params.merge!({:"skip-cache" => true}) if skip_cache?
      params.merge!({:"reset-cache" => true}) if reset_cache?
      params
    end

    private

    def skip_cache?
      @skip_cache
    end

    def reset_cache?
      @reset_cache
    end
  end
end
