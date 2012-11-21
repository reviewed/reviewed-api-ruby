module Reviewed
  class Client
    include Reviewed::Configurable

    def initialize(options={})
    end
  end
end





    class << self

      def request(method, resource_uri, params)
      end

      def get(

      def get(url)
        url = url =~ /http/ ? url : build_url(url)

        begin
          raw_response = RestClient.get(url, Util.build_request_headers)
          Reviewed::Response.new(raw_response)
        rescue RestClient::Exception => e
          raise ResourceError.new(e.message)
        end
      end

      def base_uri(url)
        url = [Reviewed.base_uri, API_VERSION, url].compact.join("/")
      end
    end

    def initialize(options={})
      @uri = 'url'
    end
  end
end
