module Reviewed
  class Response

    attr_accessor :raw
    attr_accessor :json

    def initialize(raw_response)
      @raw = raw_response
      @json = JSON.parse(raw_response).symbolize_keys!
    end
  end
end
