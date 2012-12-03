require 'spec_helper.rb'

describe Reviewed::Client do

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  describe 'accessors' do

    [:api_key, :base_uri, :request_params].each do |var|
      describe "#{var}" do

        it 'exists' do
          client.instance_variables.should include(:"@#{var}")
        end
      end
    end
  end

  describe '#configure' do

    it 'returns self' do
      client.configure{}.should be_an_instance_of(Reviewed::Client)
    end

    it 'yields self' do
      client.configure do |config|
        config.api_key = 'test_key'
      end
      client.api_key.should eql('test_key')
    end
  end

  describe '#resource' do

    context 'constant exists' do

      it 'returns the appropriate constant' do
        client.resource("articles").should eql(Reviewed::Article)
      end
    end

    context 'constant does not exist' do

      it 'returns the string' do
        client.resource("foobar").should eql("foobar")
      end
    end
  end

  describe '#method_missing' do

    before(:each) do
      @request = client.articles
    end

    it 'returns a Reviewed::Request instance' do
      @request.should be_an_instance_of(Reviewed::Request)
    end

    it 'sets the correct instance variables' do
      @request.resource.should eql(Reviewed::Article)
      @request.client.should eql(client)
    end
  end

  describe '#connnection' do

    let(:conn) { client.send(:connection) }

    it 'returns a Faraday object' do
      conn.should be_an_instance_of(Faraday::Connection)
    end

    it 'uses the UrlEncoded middleware' do
      conn.builder.handlers.should include(Faraday::Request::UrlEncoded)
    end

    it 'uses a JSON middleware' do
      conn.builder.handlers.should include(FaradayMiddleware::ParseJson)
    end

    it 'uses a Hashie middleware' do
      conn.builder.handlers.should include(FaradayMiddleware::Mashify)
    end

    it 'uses the NetHttp adapter' do
      conn.builder.handlers.should include(Faraday::Adapter::NetHttp)
    end

    it 'sets the url' do
      conn.url_prefix.to_s.should eql('http://localhost:3000/api/v1')
    end
  end
end
