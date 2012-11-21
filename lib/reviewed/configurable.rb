module Reviewed
  module Configurable

    class << self

      def options
        {
          api_key: nil,
          base_uri: 'http://localhost:3000/api',
          api_version: 'v1'
        }
      end
    end

    def configure
      yield self
      self
    end

    def verify_key!
      unless Reviewed.api_key
        raise ConfigurationError.new("Please set Reviewed.api_key before making a request")
      end
    end
  end
end
