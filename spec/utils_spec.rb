require 'spec_helper.rb'

describe Reviewed::Utils do

  class MockUtils < Reviewed::Base; end

  describe 'object_from_response' do
    use_vcr_cassette "utils/object"

    let(:article_id) { '509d166d60de7db97c05ce71' }

    it 'returns an object of the correct class' do
      response = MockUtils.object_from_response(:get, "articles/#{article_id}")
      response.should be_an_instance_of(MockUtils)
    end
  end

  describe 'collection_from_response' do
    use_vcr_cassette "utils/collection"

    it 'returns a collection object' do
      collection = MockUtils.collection_from_response(:get, "articles")
      collection.should be_an_instance_of(Reviewed::Collection)
    end

    it 'returns objects of the correct class' do
      collection = MockUtils.collection_from_response(:get, "articles")
      collection.items.each do |obj|
        obj.should be_an_instance_of(MockUtils)
      end
    end
  end

  describe 'from_response' do

    it 'returns a new object from a response' do
      MockUtils.from_response({}).should be_an_instance_of(MockUtils) 
    end
  end
end
