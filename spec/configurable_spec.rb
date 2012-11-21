require 'spec_helper.rb'

describe Reviewed::Configurable do

  let(:client) { Reviewed::Client.new }

  describe '.options' do

    it 'returns a default set of options' do
      Reviewed::Configurable.options.should be_an_instance_of(Hash)
    end
  end

  describe '#configure' do

    it 'returns self' do
      client.configure{}.should be_an_instance_of(Reviewed::Client)
    end

    it 'yields self' do
      client.configure do |config|
        config.api_key = 'test_key'
      end
      client.api_key.should eql('test_key')
    end
  end

  describe '#verify_key' do

    it 'allow when api_key is present' do
      client.base_uri.should_not be_nil
      client.verify_key!
    end

    it 'raises a ConfigurationError if api_key not present' do
      Reviewed.api_key = nil
      expect {
        client.verify_key!
      }.to raise_error(Reviewed::ConfigurationError)
    end
  end
end
