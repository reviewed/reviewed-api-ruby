require 'active_support/cache'

module Reviewed
  class Cache
    class << self
      def new(*args)
        @instance ||= super(*args)
      end

      def store
        @store ||= ActiveSupport::Cache.lookup_store(:memory_store)
      end
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      store_response = false
      serve_from_cache = true

      key = env[:url].dup
      key.query = nil

      unless self.class.store.exist?(key.to_s)
        store_response = true
      end

      if env[:url].query
        if env[:url].query.match /reset-cache/
          store_response = true
          serve_from_cache = false
        elsif env[:url].query.match /skip-cache/
          store_response = false
          serve_from_cache = false
        end
      end

      if serve_from_cache && self.class.store.exist?(key.to_s)
        Hashie::Mash.new(Marshal.load( self.class.store.read(key.to_s) ))
      else
        @app.call(env).on_complete do |resp|
          if store_response
            self.class.store.delete(key.to_s)
            self.class.store.write(key.to_s, Marshal.dump(resp))
            key.to_s
          else
            resp
          end
        end
      end
    end
  end
end
