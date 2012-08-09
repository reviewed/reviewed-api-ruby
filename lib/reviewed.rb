$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'active_support/core_ext'
require 'rest_client'

require 'reviewed/version'
require 'reviewed/base'
require 'reviewed/website'

module Reviewed
  class ConfigurationError < StandardError; end
  class ResourceError < StandardError; end

  @@config = {
    base_uri: 'http://localhost:3000/api'
  }

  def self.api_key=(token)
    @@config[:api_key] = token
  end

  def self.api_key
    @@config[:api_key]
  end

  def self.base_uri=(uri)
    @@config[:base_uri] = uri
  end

  def self.base_uri
    @@config[:base_uri]
  end
end
