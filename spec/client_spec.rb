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

  describe '#get' do

    it 'delegates to perform' do
      client.should_receive(:perform).with(:get, "path", kind_of(Hash))
      client.get("path", {})
    end
  end

  describe '#put' do

    it 'delegates to client' do
      client.should_receive(:perform).with(:put, "path", kind_of(Hash))
      client.put("path", {})
    end
  end

  describe '#post' do

    it 'delegates to client' do
      client.should_receive(:perform).with(:post, "path", kind_of(Hash))
      client.post("path", {})
    end
  end

  describe '#delete' do

    it 'delegates to request' do
      client.should_receive(:perform).with(:delete, "path", kind_of(Hash))
      client.delete("path", {})
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
      conn.url_prefix.to_s.should match('https://')
    end
  end

  describe '#perform' do

    describe 'request_params', vcr: true do

      context 'set' do

        it 'merges quest params' do
          client.request_params = { per_page: 1 }
          collection = client.articles.where({})
          collection.count.should eql(1)
        end
      end

      context 'not set' do

        it 'has nil query params' do
          collection = client.articles.where({})
          collection.count.should eql(20)
        end
      end


    end
  end

  context 'with error' do

    context 'bad response' do
      it 'should raise a Reviewed::ApiError' do
        client.connection.stub(:send).and_raise Faraday::Error::ClientError.new(true)
        lambda { client.get('something that times out') }.should raise_error(Reviewed::ApiError)
      end
    end

  end
end
