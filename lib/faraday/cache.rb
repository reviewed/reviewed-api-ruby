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
      @auth_header = env[:request_headers]['X-Reviewed-Authorization']

      if serve_from_cache && store.exist?(cache_key)
        Hashie::Mash.new(Marshal.load( store.read(cache_key) ))
      else
        @app.call(env).on_complete do |response|
          if store_response
            store.delete(cache_key)
            store.write(cache_key, Marshal.dump(response), write_options)
          end
        end
      end
    end

    private

    def serve_from_cache
      @url.query.blank? || !@url.query.match(/\b(skip|reset)-cache\b/)
    end

    def store_response
      @url.query.blank? || !@url.query.match(/\bskip-cache\b/)
    end

    def cache_key
      [@auth_header, @url.request_uri].join(':')
    end

    def write_options
      { expires_in: Integer(ENV['REVIEWED_CACHE_TIMEOUT'] || 90).minutes }
    end

  end
end
