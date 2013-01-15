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

    it 'should raise a ResourceNotFound error' do
      expect {
        test.get('/products/123')
      }.to raise_error(Reviewed::ResourceNotFound) { |e|
        e.url.should be_an_instance_of(URI::HTTP)
        e.url.to_s.should eql('http:/products/123')
        e.message.should eql('Not Found')
      }
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
