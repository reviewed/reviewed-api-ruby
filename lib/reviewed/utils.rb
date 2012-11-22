module Reviewed
  module Utils

    def self.included(klass)
      klass.extend(Reviewed::Utils::ClassMethods)
    end

    module ClassMethods

      def object_from_response(method, url, params={})
        response = Reviewed.send(method, url, params)
        self.from_response(response.body)
      end

      def collection_from_response(method, url, params={})
        response = Reviewed.send(method, url, params)
        Reviewed::Collection.new(self, response, params)
      end

      def from_response(data)
        self.new(data)
      end
    end
  end
end
