$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'faraday'
require 'faraday_middleware'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'active_model'
require 'hashie'

require 'reviewed/configurable'
require 'reviewed/embeddable'
require 'reviewed/utils'
require 'reviewed/client'
require 'reviewed/collection'
require 'reviewed/base'

require 'reviewed/product'
require 'reviewed/article'
require 'reviewed/author'
require 'reviewed/brand'
require 'reviewed/page'
require 'reviewed/website'


module Reviewed
  class ConfigurationError < StandardError; end

  class << self

    def client
      @client ||= Reviewed::Client.new
    end

    def method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      client.send(method, *args, &block)
    end
  end
end

