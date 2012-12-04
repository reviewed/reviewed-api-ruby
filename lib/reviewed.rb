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

require 'reviewed/manufacturer_spec'
require 'reviewed/brand'
require 'reviewed/product'
require 'reviewed/article'
require 'reviewed/author'
require 'reviewed/page'
require 'reviewed/website'


module Reviewed
  class ConfigurationError < StandardError; end
  class ResourceNotFound < StandardError; end
end

