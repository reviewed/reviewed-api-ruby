require 'spec_helper.rb'

describe Faraday::Errors do

  describe 'error' do
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/products/123') {[ 404, {}, { message: 'Record Not Found' } ]}
    end

    test = Faraday.new do |builder|
      builder.response :errors
      builder.response :json
      builder.adapter :test, stubs
    end

    it 'should raise a routing error' do
      expect {
        test.get('/products/123')
      }.to raise_error(Reviewed::ResourceNotFound)
    end
  end

  describe 'no error' do
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/products/123') {[ 200, {}, { message: 'Record Not Found' } ]}
    end

    test = Faraday.new do |builder|
      builder.response :errors
      builder.response :json
      builder.adapter :test, stubs
    end

    it 'should not raise an error' do
      expect {
        test.get('/products/123')
      }.to_not raise_error
    end
  end
end
