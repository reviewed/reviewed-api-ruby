require 'spec_helper'


describe Reviewed::Cache do

  describe 'call' do

    conn = Faraday.new do |builder|
      builder.use Reviewed::Cache
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/articles') { [200, {}, 'I like turtles'] }
        stub.get('/products') { [200, {}, 'Weee products'] }
      end
    end

    conn.headers = { "X-Reviewed-Authorization" => TEST_KEY }

    it "caches anything that doesn't have skip-cache or reset-cache" do
      mock_cache_val = mock
      Marshal.stub(:dump).with(hash_including(:body => 'I like turtles')).and_return(mock_cache_val)
      Reviewed::Cache.store.should_receive(:write).with("#{TEST_KEY}:/articles", mock_cache_val)
      conn.get('/articles')
    end

    it "can cache more than one thing" do
      mock_cache_val = mock
      Marshal.stub(:dump => mock_cache_val)
      Reviewed::Cache.store.should_receive(:write).with("#{TEST_KEY}:/articles", mock_cache_val)
      Reviewed::Cache.store.should_receive(:write).with("#{TEST_KEY}:/products", mock_cache_val)

      conn.get('/articles')
      conn.get('/products')
    end

    it "serves responses from the cache when fresh and does not call the app" do
      marshalled_response = Marshal.dump(body: 'old musty response')
      Reviewed::Cache.store.stub(:exist? => true)
      Reviewed::Cache.store.should_receive(:read).with("#{TEST_KEY}:/articles").and_return(marshalled_response)
      resp = conn.get '/articles'
      resp[:body].should eq("old musty response")
    end

    describe "cache busting and skipping" do
      it "does not cache responses with skip-cache as a query param" do
        Reviewed::Cache.store.should_not_receive(:read)
        Reviewed::Cache.store.should_not_receive(:write)
        conn.get '/articles', {:"skip-cache" => true}
      end

      it "replaces cached content with app response when reset-cache is a query param" do
        Reviewed::Cache.store.should_not_receive(:read)
        Reviewed::Cache.store.should_receive(:write)
        conn.get '/articles', {:"reset-cache" => true}
      end
    end

  end

end
