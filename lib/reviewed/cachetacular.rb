require 'active_support/cache'

module Reviewed
  class Cachetacular
    class << self
      def new(*args)
        @item ||= super(*args)
      end
    end

    def initialize(app, *args)
      @app = app
      @store = ActiveSupport::Cache.lookup_store(:memory_store)
    end

    def call(env)
      if @store.read(env[:url])
        if skip_caches?(env[:url])
          @app.call(env)
        elsif nuke_caches?(env[:url])
          resp = @app.call(env)
          @store.write(env[:url], Marshal.dump(resp))
          #@store[env[:url]] = Marshal.dump(resp)
          resp
        else
          Marshal.load(@store.read(env[:url]))
        end
      else
        resp = @app.call(env)
        @store.write(env[:url], Marshal.dump(resp))
        #@store[env[:url]] = Marshal.dump(resp)
        resp
      end
    end

    def skip_caches?(url)
      url.to_s.match /skip-cache/
    end

    def nuke_caches?(url)
      url.to_s.match /reset-cache/
    end
  end
end
