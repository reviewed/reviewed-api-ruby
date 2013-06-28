require 'spec_helper'

def get(path, params = {})
  conn.get(path, params) do |req|
    req.headers['X-Reviewed-Authorization'] = TEST_KEY
  end
end

describe Reviewed::Cache, vcr: true do
  let (:stubs) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('http://localhost:3000/api/v1/articles') { [200, {}, 'I like turtles'] }
      stub.get('http://localhost:3000/api/v1/products') { [200, {}, 'Weee products'] }
    end
  end

  let(:conn) do
    Faraday.new do |builder|
      builder.use Reviewed::Cache
      builder.adapter :test, stubs
    end
  end

  before(:each) do
    Reviewed::Cache.store.clear
  end

  it "caches anything that doesn't have skip-cache or reset-cache" do
    get('http://localhost:3000/api/v1/articles')
    Reviewed::Cache.store.read('http://localhost:3000/api/v1/articles').should_not be_nil
  end

  it "can cache more than one thing" do
    get('http://localhost:3000/api/v1/articles')
    get('http://localhost:3000/api/v1/products')
    Reviewed::Cache.store.read('http://localhost:3000/api/v1/articles').should_not be_nil
    Reviewed::Cache.store.read('http://localhost:3000/api/v1/products').should_not be_nil
  end

  it "always returns the same instance" do
    numero_uno = Reviewed::Cache.new("pretend this string is actually an app")
    numero_dos = Reviewed::Cache.new("pretend this string is actually an app")
    numero_uno.object_id.should eq(numero_dos.object_id)
  end

  it "serves responses from the cache when fresh and does not call the app" do
    Reviewed::Cache.store.write('http://localhost:3000/api/v1/articles', Marshal.dump(:body => "old response"))
    resp = get 'http://localhost:3000/api/v1/articles'
    resp[:body].should eq("old response")
  end

  describe "cache busting and skipping" do
    it "does not cache responses with skip-cache as a query param" do
      get 'http://localhost:3000/api/v1/articles', {:"skip-cache" => true}
      Reviewed::Cache.store.read('http://localhost:3000/api/v1/articles').should be_nil
    end

    it "replaces cached content with app response when reset-cache is a query param" do
      Reviewed::Cache.store.write('http://localhost:3000/api/v1/articles', "old response")
      get 'http://localhost:3000/api/v1/articles', {:"reset-cache" => true}
      Reviewed::Cache.store.read('http://localhost:3000/api/v1/articles').should_not eq("old response")
    end
  end
end
