require 'spec_helper.rb'

describe Reviewed::Client do

  let(:client) { Reviewed::Client.new }

  describe 'config' do

    it 'should have api_key set' do
      Reviewed::Client.api_key.should == TEST_KEY
    end

    it 'should have api_base_uri set' do
      Reviewed::Client.api_base_uri.should == TEST_URL
    end

    # redundant
    [:api_key, :api_base_uri, :api_version].each do |var|
      describe "#{var}" do
        it 'is readable' do
          lambda { client.send(var) }.should_not raise_error
        end
      end
    end

  end

  describe "accessor vars" do
    [:request_params].each do |var|
      describe var do
        it 'exists' do
          client.instance_variables.should include(:"@#{var}")
        end
      end
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

    it 'returns a Reviewed::Request instance' do
      request = client.articles
      request.should be_an_instance_of(Reviewed::Request)
    end

    it 'sets the correct instance variables' do
      request = client.articles
      request.resource.should eql(Reviewed::Article)
      request.client.should eql(client)
    end

    it 'passes arguments to the request' do
      request = client.articles(scope: "faux_scope")
      request.instance_variable_get(:@scope).should eql('faux_scope')
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
      conn.url_prefix.to_s.should match('https?://')
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
