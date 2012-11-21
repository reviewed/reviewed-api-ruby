require 'spec_helper.rb'

describe Reviewed do

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
