module Reviewed
  class Base
    extend ActiveModel::Naming

    attr_accessor :raw_response, :resource_url

    def initialize(attributes={}, raw_response=nil)
      attributes.symbolize_keys!

      unless attributes[:id].present?
        raise ResourceError.new("Resource requires an ID")
      end

      @raw_response = raw_response
      @attributes = Hashie::Mash.new(attributes)
    end

    def method_missing(sym, *args, &block)
      if @attributes.has_key?(sym)
        @attributes[sym]
      else
        super
      end
    end

    def self.find(id)
      Reviewed.verify_key!

      response = Reviewed::Request.get(resource_url(id))
      new(response.json, response.raw)
    end

    def self.all
      where({})
    end

    def self.where(options={})
      Reviewed.verify_key!

      response = Reviewed::Request.get(resource_url(nil, options))
      Collection.new(self, response.json, options)
    end

    def self.resource_name=(value)
      @resource_name = value
    end

    def self.resource_name
      @resource_name ||= self.name.split('::').last.downcase
    end

    def self.resource_url(id=nil, options={})
      url = [Reviewed.base_uri, API_VERSION, resource_name.pluralize, id].compact.join("/")
      query_string = Util.build_query_string(options)
      query_string.blank? ? url : "#{url}?#{query_string}"
    end
  end
end
