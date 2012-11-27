require 'spec_helper.rb'

describe Reviewed do

  describe 'accessors' do

    after(:each) do
      Reviewed.global_params = nil
    end

    it 'global params' do
      Reviewed.global_params = { foo: 'bar' }
      Reviewed.global_params.should eql( { foo: 'bar' } )
    end
  end

  describe '.global_params' do

    it 'returns a hash' do
      Reviewed.global_params.should eql({})
    end
  end


  describe '.client' do

    it 'returns a Reviewed::Client' do
      Reviewed.client.should be_an_instance_of(Reviewed::Client)
    end
  end

  describe '.method_missing' do

    it 'delegates to the client' do
      Reviewed::Client.any_instance.should_receive(:api_key)
      Reviewed.api_key
    end
  end
end
