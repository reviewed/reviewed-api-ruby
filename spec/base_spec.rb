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

    it 'should have a default client if one is not passed' do
      obj = Example.new( { foo: 'bar' })
      obj.client.should be_an_instance_of(Reviewed::Client)
    end

    it 'should have a client if passed in' do
      obj = Example.new( { foo: 'bar' }, "client" )
      obj.client.should eql('client')
    end
  end

  describe 'to_path' do

    it 'results in class demodulized resource name' do
      Reviewed::Article.to_path.should eql("articles")
    end

    it 'scoped within to_param of parent_scope' do
      example = Example.new({})
      example.stub :to_param => 'hoopy-frood'
      Reviewed::Attachment.to_path(example).should eql("examples/hoopy-frood/attachments")
    end

    it 'builds instance url from an instance' do
      example = Example.new({})
      example.stub :to_param => 'hoopy-frood'
      example.to_path.should == 'examples/hoopy-frood'
    end

  end

  describe 'association_name' do

    it 'returns the demodulized & pluralized version of itself' do
      Reviewed::Article.association_name.should eql("articles")
    end

    it 'works for multi word module names' do
      module Reviewed
        class FooBar < Base
        end
      end
      Reviewed::FooBar.association_name.should eql("foo_bars")
    end
  end

  describe 'attributes' do
    before(:each) do
      @timestamp = Time.parse("01/01/2013 10:00:00 GMT")
      @model = Example.new(id: 'id', super_awesome: 'true', created_at: @timestamp.to_s, updated_at: @timestamp.to_s)
    end

    it 'returns the named attribute (via method missing)' do
      @model.super_awesome.should == 'true'
    end

    it 'has a created at timestamp' do
      @model.created_at.should == @timestamp
    end

    it 'has an updated at timestamp' do
      @model.updated_at.should == @timestamp
    end
  end

  describe 'respond_to?' do
    before(:each) do
      @model = Example.new(id: 'id', super_awesome: 'true')
    end

    it 'takes attributes into consideration' do
      @model.respond_to?(:super_awesome).should be_true
    end

    it 'preserves the original behavior' do
      @model.respond_to?(:fafafa).should be_false
    end
  end
end
