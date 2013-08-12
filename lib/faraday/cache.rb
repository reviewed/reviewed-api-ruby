require 'reviewed/cache'

module Faraday
  class Cache

    def initialize(app)
      @app = app
    end

    def store
      Reviewed::Cache.store
    end

    def call(env)
      @url = env[:url]

      @website_id = env[:request_headers]['x-reviewed-website']

      if serve_from_cache? && store.exist?(cache_key)
        begin
          Hashie::Mash.new(MultiJson.load( store.read(cache_key) ))
        rescue => e
          raise e.message + ": #{cache_key}"
        end
      else
        @app.call(env).on_complete do |response|
          if store_response?(response)
            store.delete(cache_key)
            storeable_response = MultiJson.dump(response.slice(:status, :body, :response_headers))
            store.write(cache_key, storeable_response, write_options)
          end
        end
      end
    end

    private

    def serve_from_cache?
      @url.query.blank? || !@url.query.match(/\b(skip|reset)-cache\b/)
    end

    def store_response?(resp)
      return false if resp[:status] != 200
      @url.query.blank? || !@url.query.match(/\bskip-cache\b/)
    end

    def cache_key
      [@website_id, @url.request_uri].join(':')
    end

    def write_options
      { expires_in: Integer(ENV['REVIEWED_CACHE_TIMEOUT'] || 90).minutes }
    end

  end
end
