require 'active_support/cache'

module Reviewed
  class Cache

    def self.store
      @store ||= ActiveSupport::Cache.lookup_store(:redis_store, ENV["REDISCLOUD_URL"], {expires_in: 90.minutes})
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      @url = env[:url]

      if serve_from_cache && self.class.store.exist?(cache_key)
        Hashie::Mash.new(Marshal.load( self.class.store.read(cache_key) ))
      else
        @app.call(env).on_complete do |response|
          if store_response
            self.class.store.delete(cache_key)
            self.class.store.write(cache_key, Marshal.dump(response))
            cache_key
          else
            response
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
      @url.request_uri
    end

  end
end
