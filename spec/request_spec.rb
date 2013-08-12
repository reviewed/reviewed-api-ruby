require 'spec_helper.rb'

describe Reviewed::Request do
  before do
    Reviewed::Cache.store.clear
  end

  let(:request) do
    Reviewed::Request.new(
      resource: Reviewed::Article
    )
  end

  describe 'initialize' do

    context 'class' do

      it 'sets the path' do
        request.path.should eql('articles')
      end

      it 'sets the resource' do
        request.resource.should eql(Reviewed::Article)
      end
    end

    context 'resource' do

      it 'with resource as string, sets the path to the resource' do
        request = Reviewed::Request.new(resource: 'test')
        request.path.should eql('test')
      end

      it 'with resource as an object, calls :to_path on it' do
        article_class = double
        article_class.should_receive(:to_path).and_return('article')
        request = Reviewed::Request.new(resource: article_class)
        request.path.should eql('article')
      end
    end

    context 'scoped resource' do
      it 'calls to path with the given scope param' do
        article_class = double
        scope = double
        article_class.should_receive(:to_path).with(scope)
        request = Reviewed::Request.new(resource: article_class, scope: scope)
        request.path
      end
    end
  end

  it "does not use cached version when with_no_cache is used" do
    request.with_no_cache.should be_uncached
  end

  it "caches requests that haven't been called with with_no_cache or with_new_cache" do
    request.should be_cached
  end

  it "calls client with skip-cache if with_no_cache is used" do
    client = Reviewed::Client.new
    client.articles.with_no_cache.cache_control_params.should include(:"skip-cache")
  end

  it "calls client with reset-cache if with_new_cache is used" do
    client = Reviewed::Client.new
    client.articles.with_new_cache.cache_control_params.should include(:"reset-cache")
  end

  describe '#find' do

    it 'delegates to object_from_response' do
      request.should_receive(:object_from_response).with(:get, "articles/123", {})
      request.find(123)
    end

    it 'cgi escapes id params' do
      request.should_receive(:object_from_response).with(:get, "articles/Smith+%26+Wesson+v%2Fs+Colt%3A+Which+Makes+you+Manlier%3F", {})
      request.find('Smith & Wesson v/s Colt: Which Makes you Manlier?')
    end
  end

  describe '#where', vcr: true do

    it 'delegates to object_from_response' do
      request.should_receive(:collection_from_response).with(:get, "articles", {})
      request.where
    end

    it 'returns a collection' do
      collection = request.where
      collection.class.should == Reviewed::Collection
    end

    it 'returns the appropriate page of results' do
      collection = request.where(:page => 2)
      collection.total.should > 1
      collection.current_page.should == 2
    end

    it 'filters collections using keywords' do
      collection = request.where(:keywords => 'Zenbook,UX31E')
      collection.total.should == 1
      collection.last_page.should be_true
    end

    it 'returns an empty set if no matching data was found' do
      collection = request.where(:keywords => 'TQ')
      collection.should be_empty
      collection.total.should == 0
      collection.out_of_bounds.should be_true
    end
  end

  describe '#all' do

    it 'delegates to where' do
      request.should_receive(:where).with({})
      request.all
    end
  end

  describe 'object_from_response', vcr: true do

    let(:article_id) { 'big-green-egg-medium-charcoal-grill-review' }

    it 'returns an object of the correct class' do
      response = request.object_from_response(:get, "articles/#{article_id}")
      response.should be_an_instance_of(request.resource)
    end
  end

  describe 'collection_from_response', vcr: true do

    it 'returns a collection object' do
      collection = request.collection_from_response(:get, "articles")
      collection.should be_an_instance_of(Reviewed::Collection)
    end

    it 'returns objects of the correct class' do
      collection = request.collection_from_response(:get, "articles")
      collection.items.each do |obj|
        obj.should be_an_instance_of(request.resource)
      end
    end
  end
end
