require 'spec_helper.rb'

describe Reviewed::Request do

  let(:request) do
    Reviewed::Request.new(
      resource: Reviewed::Article,
      client: Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
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

    context 'string' do

      let(:request) { Reviewed::Request.new(resource: 'test') }

      it 'sets the path' do
        request = Reviewed::Request.new(resource: 'test')
        request.path.should eql('test')
      end

      it 'does not set the resource' do
        request.resource.should be_nil
      end
    end
  end

  describe '#get' do

    it 'delegates to perform' do
      request.should_receive(:perform).with(:get, "path", kind_of(Hash))
      request.get("path", {})
    end
  end

  describe '#put' do

    it 'delegates to request' do
      request.should_receive(:perform).with(:put, "path", kind_of(Hash))
      request.put("path", {})
    end
  end

  describe '#post' do

    it 'delegates to request' do
      request.should_receive(:perform).with(:post, "path", kind_of(Hash))
      request.post("path", {})
    end
  end

  describe '#delete' do

    it 'delegates to request' do
      request.should_receive(:perform).with(:delete, "path", kind_of(Hash))
      request.delete("path", {})
    end
  end

  describe '#find' do

    it 'delegates to object_from_response' do
      request.should_receive(:object_from_response).with(:get, "articles/123", {})
      request.find(123)
    end
  end

  describe '#where' do
    use_vcr_cassette 'request/where/collection'

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

    it 'filters collections using other supported options' do
      collection = request.where(:keywords => 'minden')
      collection.total.should == 1
      collection.last_page.should be_true
    end

    it 'returns an empty set if no matching data was found' do
      collection = request.where(:keywords => 'doesnotcompute')
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

  describe 'object_from_response' do
    use_vcr_cassette "request/object"

    let(:article_id) { '509d166d60de7db97c05ce71' }

    it 'returns an object of the correct class' do
      response = request.object_from_response(:get, "articles/#{article_id}")
      response.should be_an_instance_of(request.resource)
    end
  end

  describe 'collection_from_response' do
    use_vcr_cassette "request/collection"

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
