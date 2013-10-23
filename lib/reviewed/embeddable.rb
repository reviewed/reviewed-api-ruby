module Reviewed
  module Embeddable

    def self.included(klass)
      klass.extend(Reviewed::Embeddable::ClassMethods)
    end

    class << self
      def embedded_name(name, opts_name=nil)
        return opts_name if opts_name
        ["Reviewed", name.singularize.classify].join("::")
      end
    end

    def objectify(data)
      data = objectify_has_many(data)
      data = objectify_has_one(data)
      return data
    end

    def objectify_has_many(json)
      self.class._embedded_many.each do |map|
        assoc_name, klass_name = [map.keys[0], map.values[0]]
        klass = klass_name.constantize
        if json.has_key?(assoc_name)
          json[assoc_name] = json[assoc_name].map do |obj|
            klass.new(obj)
          end
        end
      end
      return json
    end

    def objectify_has_one(json)
      self.class._embedded_one.each do |map|
        assoc_name, klass_name = [map.keys[0], map.values[0]]
        klass = klass_name.constantize
        if json.has_key?(assoc_name)
          json[assoc_name] = klass.new(json[assoc_name])
        end
      end
      return json
    end

    module ClassMethods
      attr_accessor :_embedded_many, :_embedded_one

      def has_attachments
        include Attachable
      end

      def has_many(name, opts={})
        klass_string = Reviewed::Embeddable.embedded_name(name.to_s, opts[:class_name])
        association = opts[:as] || name
        _embedded_many << { association.to_s => klass_string }
      end

      def has_one(name, opts={})
        klass_string = Reviewed::Embeddable.embedded_name(name.to_s, opts[:class_name])
        association = opts[:as] || name
        _embedded_one << { association.to_s => klass_string }
      end

      def _embedded_many
        @_embedded_many ||= []
      end

      def _embedded_one
        @_embedded_one ||= []
      end
    end
  end
end
