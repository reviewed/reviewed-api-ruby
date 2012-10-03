require 'spec_helper'

module Reviewed
  class Example < Base
  end
end

module Reviewed
  class Article < Base
  end
end

describe Reviewed::Base do
  before(:each) do
    Reviewed.api_key = TEST_KEY
  end

  describe 'initialization' do
    it 'raises an error if a resource ID is not present' do
      expect {
        Reviewed::Example.new
      }.to raise_error(Reviewed::ResourceError)
    end

    it 'returns a value' do
      model = Reviewed::Example.new(id: 1234, name: 'Test')
      model.id.should == 1234
    end
  end

  describe 'find' do
    before(:each) do
      Reviewed::Example.resource_name = 'article' # test
    end

    it 'raises an error if the api key is not set' do
      Reviewed.api_key = nil

      expect {
        Reviewed::Example.find('test')
      }.to raise_error(Reviewed::ConfigurationError)
    end

    context 'with a valid request' do
      use_vcr_cassette 'base/find_ok'

      it 'fetches content from the api' do
        model = Reviewed::Example.find('506b0b46bd02862270000747')
        model.raw_response.should_not be_nil
      end

      it 'parses response json and returns an object' do
        model = Reviewed::Example.find('506b0b46bd02862270000747')
        model.class.should == Reviewed::Example
        model.id.should == '506b0b46bd02862270000747'
        model.name.should == 'Minden Master II Grill Review'
      end
    end

    context 'with an invalid request' do
      use_vcr_cassette 'base/find_error_key'

      it 'complains if the api key is unauthorized' do
        Reviewed.api_key = 'xxxxxxxxxxxxxxxx'

        expect {
          Reviewed::Example.find('50241b9c5da4ac8d38000001')
        }.to raise_error(Reviewed::ResourceError, /unauthorized/i)
      end

      it 'complains if the requested resource is not found' do
        expect {
          Reviewed::Example.find('notfound')
        }.to raise_error(Reviewed::ResourceError, /not found/i)
      end
    end
  end

  describe 'where' do
    use_vcr_cassette 'base/where_collection'

    it 'returns a collection' do
      collection = Reviewed::Article.all
      collection.class.should == Reviewed::Collection
    end

    it 'returns the appropriate page of results' do
      collection = Reviewed::Article.where(:page => 2)
      collection.total.should > 1
      collection.current_page.should == 2
    end

    it 'filters collections using other supported options' do
      collection = Reviewed::Article.where(:keywords => 'minden')
      collection.total.should == 1
      collection.last_page.should be_true
    end

    it 'returns an empty set if no matching data was found' do
      collection = Reviewed::Article.where(:keywords => 'doesnotcompute')
      collection.should be_empty
      collection.total.should == 0
      collection.out_of_bounds.should be_true
    end
  end

  describe 'attributes' do
    it 'returns the named attribute (via method missing)' do
      model = Reviewed::Example.new(:id => 'id', :super_awesome => 'true')
      model.super_awesome.should == 'true'
    end
  end

  describe 'resource url' do
    it 'returns an individual resource' do
      Reviewed::Example.resource_url('article-123').should == 'https://the-guide-staging.herokuapp.com/api/v1/articles/article-123'
    end

    it 'returns a collection of resources' do
      Reviewed::Example.resource_url(nil).should == 'https://the-guide-staging.herokuapp.com/api/v1/articles'
    end

    it 'includes a query parameter' do
      Reviewed::Example.resource_url(nil, page: 2).should == 'https://the-guide-staging.herokuapp.com/api/v1/articles?page=2'
    end
  end
end
