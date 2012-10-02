module Reviewed
  class Request

    class << self

      def get(url)
        url = url =~ /http/ ? url : build_url(url)

        begin
          raw_response = RestClient.get(url, Util.build_request_headers)
          Reviewed::Response.new(raw_response)
        rescue RestClient::Exception => e
          raise ResourceError.new(e.message)
        end
      end

      def build_url(url)
        url = [Reviewed.base_uri, API_VERSION, url].compact.join("/")
      end
    end
  end
end

