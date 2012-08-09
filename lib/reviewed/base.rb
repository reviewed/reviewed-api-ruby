module Reviewed
  class Base
    attr_accessor :raw_response

    def initialize(attributes={}, raw_response=nil)
      attributes.symbolize_keys!

      unless attributes[:id].present?
        raise ResourceError.new("Resource requires an ID")
      end

      @raw_response = raw_response
      @attributes = attributes
    end

    def method_missing(sym, *args, &block)
      @attributes[sym]
    end

    def self.find(id)
      unless Reviewed.api_key.present?
        raise ConfigurationError.new("Please set Reviewed.api_key before making a request")
      end

      headers = {}
      headers['X-Reviewed-Authorization'] = Reviewed.api_key
      headers['accept'] = 'json'
      url = "#{Reviewed.base_uri}/#{API_VERSION}/#{resource_name.pluralize}/#{id}"

      begin
        response = RestClient.get(url, headers)
        new(JSON.parse(response), response)
      rescue RestClient::Exception => e
        raise ResourceError.new(e.message)
      end
    end

    def self.resource_name=(value)
      @resource_name = value
    end

    def self.resource_name
      @resource_name ||= self.name.split('::').last.downcase
    end
  end
end
