$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'active_support/core_ext'
require 'rest_client'
require 'active_model'
require 'hashie'
require 'forwardable'

require 'reviewed/version'
require 'reviewed/util'
require 'reviewed/base'
require 'reviewed/collection'
require 'reviewed/request'
require 'reviewed/response'

require 'reviewed/website'
require 'reviewed/product'
require 'reviewed/author'
require 'reviewed/brand'
require 'reviewed/article'

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

  def self.verify_key!
    if Reviewed.api_key.present?
      true
    else
      raise ConfigurationError.new("Please set Reviewed.api_key before making a request")
    end
  end
end
