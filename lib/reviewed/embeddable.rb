module Reviewed
  module Embeddable

    def self.included(klass)
      klass.extend(Reviewed::Embeddable::ClassMethods)
    end

    class << self

      def embedded_class(name, opts_name=nil)
        name = opts_name ? opts_name : embedded_name(name)
        name.constantize
      end

      def embedded_name(name)
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
        key, value = [map.keys[0], map.values[0]]

        if json.has_key?(key)
          json[key] = json[key].map do |obj|
            value.new(obj)
          end
        end
      end
      return json
    end

    def objectify_has_one(json)
      self.class._embedded_one.each do |map|
        key, value = [map.keys[0], map.values[0]]

        if json.has_key?(key)
          json[key] = value.new(json[key])
        end
      end
      return json
    end

    module ClassMethods
      attr_accessor :_embedded_many, :_embedded_one

      def has_many(name, opts={})
        klass = Reviewed::Embeddable.embedded_class(name.to_s, opts[:class_name])
        association = opts[:as] || name
        _embedded_many << { association.to_s => klass }
      end

      def has_one(name, opts={})
        klass = Reviewed::Embeddable.embedded_class(name.to_s, opts[:class_name])
        association = opts[:as] || name
        _embedded_one << { association.to_s => klass }
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
