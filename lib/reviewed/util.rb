module Reviewed
  class Util
    def self.build_request_headers(headers={})
      headers['X-Reviewed-Authorization'] ||= Reviewed.api_key
      headers['accept'] ||= 'json'
      headers.stringify_keys!
    end

    def self.build_query_string(hash={})
      hash.keys.inject('') do |query_string, key|
        query_string << '&' unless key == hash.keys.first
        query_string << "#{URI.encode(key.to_s)}=#{URI.encode(hash[key].to_s)}"
      end
    end
  end
end
