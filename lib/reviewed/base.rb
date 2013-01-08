require 'active_model'

module Reviewed
  class Base
    include ::Reviewed::Embeddable

    extend ::ActiveModel::Naming

    attr_accessor :attributes

    def initialize(data)
      self.attributes = objectify(data)
    end

    def created_at
      if @attributes.has_key?(:created_at)
        Time.parse(@attributes[:created_at])
      else
        nil
      end
    end

    def updated_at
      if @attributes.has_key?(:updated_at)
        Time.parse(@attributes[:updated_at])
      else
        nil
      end
    end

    class << self

      def path
        @resource_name ||= association_name
      end

      def association_name
        self.name.demodulize.downcase.pluralize
      end
    end

    def respond_to?(sym, include_private=false)
      return true if super
      @attributes.has_key?(sym)
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
