require 'spec_helper.rb'

describe Faraday::ApiKey do

  describe 'error' do

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/products/123') {[ 200, {foo: 'hi'}, '']}
    end

    test = Faraday.new do |builder|
      builder.request :api_key
      builder.adapter :test, stubs
    end

    it 'should raise a configuration error' do
      expect {
        test.get('/products/123')
      }.to raise_error(Reviewed::ConfigurationError)
    end
  end

  describe 'no error' do

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/products/123') {[ 200, {foo: 'hi'}, '']}
    end

    test = Faraday.new do |builder|
      builder.request :api_key
      builder.adapter :test, stubs
    end

    test.headers = { "X-Reviewed-Authorization" => '123' }

    it 'should not raise an error' do
      expect {
        test.get('/products/123')
      }.to_not raise_error
    end
  end
end
