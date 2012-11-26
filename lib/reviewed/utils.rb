module Reviewed
  module Utils

    def self.included(klass)
      klass.extend(Reviewed::Utils::ClassMethods)
    end

    module ClassMethods

      def object_from_response(method, url, params={})
        response = Reviewed.send(method, url, params)
        self.new(response.body)
      end

      def collection_from_response(method, url, params={})
        response = Reviewed.send(method, url, params)
        Reviewed::Collection.new(self, response, params)
      end
    end
  end
end
