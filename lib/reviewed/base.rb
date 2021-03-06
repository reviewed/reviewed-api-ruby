require 'active_model'

module Reviewed
  class Base

    include ::Reviewed::Embeddable

    extend ::ActiveModel::Naming

    attr_accessor :attributes, :client

    def initialize(data, client = Reviewed::Client.new)
      @attributes = objectify(data)
      @client = client
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

    def to_s
      "\#<#{self.class.name}:#{self.id}>"
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
        klass.name.demodulize.underscore.pluralize
      end

    end

    def to_path
      [self.class.to_path, self.to_param].join('/')
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
