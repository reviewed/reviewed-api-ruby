require 'spec_helper'

module Reviewed
  class Example < Base
  end
end

describe Reviewed::Base do
  describe 'initialize' do
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
      Reviewed.api_key = 'bdc3228106bfcfd2a324957b7f2afb6c'
      Reviewed::Example.resource_name = 'website' # test
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
        model = Reviewed::Example.find('50241b9c5da4ac8d38000001')
        model.raw_response.should_not be_nil
      end

      it 'parses response json and returns an object' do
        model = Reviewed::Example.find('50241b9c5da4ac8d38000001')
        model.id.should == '50241b9c5da4ac8d38000001'
        model.name.should == 'test website'
      end
    end

    context 'with an invalid request' do
      use_vcr_cassette 'base/find_error_key'

      it 'should complain if the api key is unauthorized' do
        Reviewed.api_key = 'xxxxxxxxxxxxxxxx'
        expect {
          Reviewed::Example.find('50241b9c5da4ac8d38000001')
        }.to raise_error(Reviewed::ResourceError, /unauthorized/i)
      end

      it 'should complain if the requested resource is not found' do
        expect {
          Reviewed::Example.find('notfound')
        }.to raise_error(Reviewed::ResourceError, /not found/i)
      end
    end
  end

  describe 'attributes' do
    it 'returns the named attribute (via method missing)' do
      model = Reviewed::Example.new(:id => 'id', :super_awesome => 'true')
      model.super_awesome.should == 'true'
    end
  end
end
