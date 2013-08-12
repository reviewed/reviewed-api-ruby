require 'spec_helper'


describe Faraday::Cache do

  describe 'call' do

    conn = Faraday.new do |builder|
      builder.use Faraday::Cache
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/articles') { [200, {}, 'I like turtles'] }
        stub.get('/products') { [200, {}, 'Weee products'] }
        stub.get('/kaboom') { [500, {}, 'Kaboom'] }
      end
    end

    conn.headers = { "X-Reviewed-Website" => 'f0000123' }

    it "caches anything that doesn't have skip-cache or reset-cache" do
      mock_cache_val = double
      MultiJson.stub(:dump).with(hash_including(:body => 'I like turtles')).and_return(mock_cache_val)
      Reviewed::Cache.store.should_receive(:write).with("f0000123:/articles", mock_cache_val, anything)
      conn.get('/articles')
    end

    it "can cache more than one thing" do
      mock_cache_val = double
      MultiJson.stub(:dump => mock_cache_val)
      Reviewed::Cache.store.should_receive(:write).with("f0000123:/articles", mock_cache_val, anything)
      Reviewed::Cache.store.should_receive(:write).with("f0000123:/products", mock_cache_val, anything)

      conn.get('/articles')
      conn.get('/products')
    end

    it "serves responses from the cache when fresh and does not call the app" do
      marshalled_response = MultiJson.dump(body: 'old musty response')
      Reviewed::Cache.store.stub(:exist? => true)
      Reviewed::Cache.store.should_receive(:read).with("f0000123:/articles").and_return(marshalled_response)
      resp = conn.get '/articles'
      resp[:body].should eq("old musty response")
    end

    it "does not store response when result is 500" do
      Reviewed::Cache.store.should_not_receive(:write)
      conn.get('/kaboom')
    end

    describe "cache busting and skipping" do
      it "does not cache responses with skip-cache as a query param" do
        Reviewed::Cache.store.should_not_receive(:read)
        Reviewed::Cache.store.should_not_receive(:write)
        conn.get '/articles', {:"skip-cache" => true}
      end

      it "replaces cached content with app response when reset-cache is a query param" do
        mock_cache_val = double
        MultiJson.stub(:dump).and_return(mock_cache_val)
        Reviewed::Cache.store.should_not_receive(:read)
        Reviewed::Cache.store.should_receive(:write)
        conn.get '/articles', {:"reset-cache" => true}
      end
    end

  end

end
