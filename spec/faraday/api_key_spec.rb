require 'spec_helper.rb'
require 'ostruct'

describe Faraday::ApiKey do

  class FauxApp
    def call(env)
      return env
    end
  end

  let(:faraday) { Faraday::ApiKey.new(FauxApp.new) }
  let(:env) { {} }

  describe 'call' do

    context 'no auth token' do

      it 'raises Reviewed::ConfigurationError' do
        expect {
          faraday.call(env)
        }.to raise_error
      end
    end

    context 'auth token' do

      let(:env) { OpenStruct.new(request: OpenStruct.new({ headers: {'X-Reviewed-Authorization' => '123'} })) }

      it 'does not error' do
        expect {
          faraday.call(env)
        }.to_not raise_error
      end
    end
  end
end
