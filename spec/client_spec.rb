require 'spec_helper.rb'

describe Reviewed::Client do

  let(:client) { Reviewed::Client.new }

  describe 'variables' do

    [:api_key, :base_uri, :api_version].each do |var|
      describe "#{var}" do

        it 'exists' do
          client.instance_variables.should include(:"@#{var}")
        end
      end
    end
  end

  describe '#delete' do

    it 'delegates to request' do
      client.should_receive(:request).with(:delete, "path", kind_of(Hash))
      client.delete("path", {})
    end
  end

  describe '#get' do

    it 'delegates to request' do
      client.should_receive(:request).with(:get, "path", kind_of(Hash))
      client.get("path", {})
    end
  end

  describe '#post' do

    it 'delegates to request' do
      client.should_receive(:request).with(:post, "path", kind_of(Hash))
      client.post("path", {})
    end
  end

  describe '#put' do

    it 'delegates to request' do
      client.should_receive(:request).with(:put, "path", kind_of(Hash))
      client.put("path", {})
    end
  end

  describe '#url' do

    it 'returns a url' do
      client.url.should eql('http://localhost:3000/api/v1')
    end
  end

  describe '#request' do

    it 'verifies the key' do
      client.stub_chain(:connection, :send).and_return(nil)
      client.should_receive(:verify_key!)
      client.send(:request, :get, 'test')
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

    it 'uses the NetHttp adapter' do
      conn.builder.handlers.should include(Faraday::Adapter::NetHttp)
    end

    it 'sets the url' do
      conn.url_prefix.to_s.should eql('http://localhost:3000/api/v1')
    end
  end
end
