$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'faraday'
require 'faraday_middleware'
require 'faraday/api_key'
require 'faraday/errors'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'active_model'
require 'hashie'
require 'rack'

require 'reviewed/embeddable'
require 'reviewed/request'
require 'reviewed/client'
require 'reviewed/collection'
require 'reviewed/base'
require 'reviewed/attachable'

require 'reviewed/manufacturer_spec'
require 'reviewed/award'
require 'reviewed/brand'
require 'reviewed/product'
require 'reviewed/deal'
require 'reviewed/hero'
require 'reviewed/article'
require 'reviewed/author'
require 'reviewed/page'
require 'reviewed/website'
require 'reviewed/cachetacular'

module Reviewed
  class BaseError < StandardError
    attr_accessor :url

    def initialize(opts={})
      @url = opts[:url]
      super(opts[:msg])
    end
  end
  class ConfigurationError < Reviewed::BaseError; end
  class ResourceNotFound < Reviewed::BaseError; end
  class ApiError < Reviewed::BaseError; end
end

