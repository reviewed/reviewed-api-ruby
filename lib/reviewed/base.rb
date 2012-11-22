require 'active_model'

module Reviewed
  class Base
    include ::Reviewed::Embeddable
    include ::Reviewed::Utils

    extend ::ActiveModel::Naming

    attr_accessor :attributes

    def initialize(data)
      self.attributes = objectify(data)
    end

    class << self

      def find(id, params={})
        object_from_response(:get, "#{resource_url}/#{id}", params)
      end

      def where(params={})
        collection_from_response(:get, resource_url, params)
      end

      def all
        where({})
      end

      def resource_url
        @resource_name ||= self.name.demodulize.downcase.pluralize
      end
    end

    def method_missing(sym, *args, &block)
      if @attributes.has_key?(sym)
        @attributes[sym]
      else
        super
      end
    end
  end
end
