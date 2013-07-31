require 'active_support/cache'
require 'singleton'

module Reviewed
  class Cache
    include Singleton

    def self.store
      @store ||= if ENV['REVIEWED_CACHE_REDIS_URL']
                   puts "Reviewed::Cache - connecting to #{ENV['REVIEWED_CACHE_REDIS_URL']}"
                   ActiveSupport::Cache.lookup_store(:redis_store, ENV['REVIEWED_CACHE_REDIS_URL'])
                 else
                   ActiveSupport::Cache.lookup_store(:memory_store)
                 end
    end

  end
end
