require 'spec_helper'

describe Reviewed::Base do

  let(:article_id) { '509d166d60de7db97c05ce71' }

  class Example < Reviewed::Base; end

  describe 'Class' do

    it 'responds to model_name' do
      Example.model_name.should eql("Example")
    end
  end

  describe 'initialize' do

    it 'objectifies data' do
      Example.any_instance.should_receive(:objectify).with({})
      obj = Example.new( {} )
    end

    it 'sets the data in the @attributes var' do
      obj = Example.new( { foo: 'bar' } )
      obj.instance_variable_get(:@attributes).should eql( { foo: 'bar' } )
    end
  end

  describe 'find' do
    use_vcr_cassette 'base/article/find'

    it 'returns an article' do
      Reviewed::Article.find("#{article_id}").should be_an_instance_of(Reviewed::Article)
    end

    it 'calls object_from_response with correct params' do
      Reviewed::Article.should_receive(:object_from_response).with(
        :get, "articles/#{article_id}", {}
      )
      Reviewed::Article.find("#{article_id}")
    end
  end

  describe 'resource_url' do

    it 'should the demodulized resource name' do
      Reviewed::Article.resource_url.should eql("articles")
    end
  end

  describe 'where' do
    use_vcr_cassette 'base/where_collection'

    it 'returns a collection' do
      collection = Reviewed::Article.where
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

  describe 'all' do

    it 'calls where with empty params' do
      Reviewed::Article.should_receive(:where).with({})
      Reviewed::Article.all
    end
  end

  describe 'attributes' do
    it 'returns the named attribute (via method missing)' do
      model = Example.new(:id => 'id', :super_awesome => 'true')
      model.super_awesome.should == 'true'
    end
  end

  describe 'resource_url' do

    it 'returns the pluralized demodulized class name' do
      Reviewed::Article.resource_url.should eql('articles')
      Example.resource_url.should eql('examples')
    end
  end
end
