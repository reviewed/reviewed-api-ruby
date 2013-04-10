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

      # poor man's polymorphic_url
      def to_path parent_scope=nil
        if parent_scope && parent_scope.respond_to?(:to_param)
          [association_name(parent_scope.class), parent_scope.to_param, association_name].join('/')
        else
          association_name
        end
      end

      def association_name klass=nil
        klass ||= self
        klass.name.demodulize.downcase.pluralize
      end

    end


    def to_param
      id
    end

    def respond_to?(sym, include_private=false)
      super || @attributes.has_key?(sym)
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
