$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'faraday'
require 'active_support/inflector'
require 'reviewed/configurable'
require 'reviewed/embeddable'
require 'reviewed/utils'
require 'reviewed/client'
require 'reviewed/base'
require 'reviewed/article'
require 'active_model'
require 'hashie'

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

