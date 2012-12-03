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

  describe 'path' do

    it 'should the demodulized resource name' do
      Reviewed::Article.path.should eql("articles")
    end
  end

  describe 'association_name' do

    it 'returns the demodulized & pluralized version of itself' do
      Reviewed::Article.association_name.should eql("articles")
    end
  end

  describe 'attributes' do
    it 'returns the named attribute (via method missing)' do
      model = Example.new(:id => 'id', :super_awesome => 'true')
      model.super_awesome.should == 'true'
    end
  end
end
