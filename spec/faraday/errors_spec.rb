require 'spec_helper.rb'

describe Faraday::Errors do

  describe 'error' do
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/products/123') {[ 404, {}, { message: 'Record Not Found' } ]}
    end

    stubs2 = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/products/123') {[ 500, {}, '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> <html> <head> <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1"> <style type="text/css"> html, body, iframe { margin: 0; padding: 0; height: 100%; } iframe { display: block; width: 100%; border: none; } </style> <title>Application Error</title></head> </head> <body> <iframe src="//s3.amazonaws.com/heroku_pages/error.html"> <p>Application Error</p> </iframe> </body> </html>' ]}
    end

    test = Faraday.new do |builder|
      builder.response :errors
      builder.response :json
      builder.adapter :test, stubs
    end

    test2 = Faraday.new do |builder|
      builder.response :errors
      builder.response :json
      builder.adapter :test, stubs2
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

    context 'faraday catch-all' do

      it 'raises an ApiError error' do
        client = Reviewed::Client.new
        client.stub!(:connection).and_return(test2)
        expect {
          client.send(:perform, :get, '/products/123')
        }.to raise_error(Reviewed::ApiError)
      end

      it 'passes other Reviewed errors through' do
        client = Reviewed::Client.new
        client.stub!(:connection).and_raise(Reviewed::ConfigurationError.new)
        expect {
            client.send(:perform, :get, '/products/123')
          }.to raise_error(Reviewed::ConfigurationError)
      end
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
