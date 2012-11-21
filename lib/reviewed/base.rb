require 'active_model'

module Reviewed
  class Base
    extend ::ActiveModel::Naming
    extend ::Reviewed::Embeddable

    include ::Reviewed::Utils

    attr_accessor :attributes
    #attr_accessor :raw_response, :resource_url

    def initialize(data)
      @attributes = Hashie::Mash.new(data)
    end

    class << self

      def find(id)
        #object_from_response(:get, "articles/#{}")
        #new(response.json, response.raw)
      end

      def all
        where({})
      end

      def where(options={})
        Reviewed.verify_key!

        response = Reviewed::Resource.get(resource_url(nil, options))
        Collection.new(self, response.json, options)
      end

      def resource_name=(value)
        @resource_name = value
      end

      def resource_name
        @resource_name ||= self.name.split('::').last.downcase
      end

      def resource_url(id=nil, options={})
        url = [Reviewed.base_uri, API_VERSION, resource_name.pluralize, id].compact.join("/")
        query_string = Util.build_query_string(options)
        query_string.blank? ? url : "#{url}?#{query_string}"
      end
    end



    #def initialize(attributes={}, raw_response=nil)
      #attributes.symbolize_keys!

      #unless attributes[:id].present?
        #raise ResourceError.new("Resource requires an ID")
      #end

      #@raw_response = raw_response
      #@attributes = Hashie::Mash.new(attributes)
    #end

    def method_missing(sym, *args, &block)
      if @attributes.has_key?(sym)
        @attributes[sym]
      else
        super
      end
    end
  end
end
