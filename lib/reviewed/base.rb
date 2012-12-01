require 'active_model'

module Reviewed
  class Base
    include ::Reviewed::Embeddable

    extend ::ActiveModel::Naming

    attr_accessor :attributes

    class << self

      def to_s
        @resource_name ||= self.name.demodulize.downcase.pluralize
      end
    end

    def initialize(data)
      self.attributes = objectify(data)
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
