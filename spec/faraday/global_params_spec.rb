require 'spec_helper.rb'

describe Faraday::GlobalParams do

  class FauxApp
    def call(env)
      return env
    end
  end

  let(:faraday) { Faraday::GlobalParams.new(FauxApp.new) }
  let(:env) { { url: URI.parse("http://www.the-guide-staging.com/api/v1/articles") } }

  context 'branch present' do

    before(:each) do
      Reviewed.stub!(:global_params).and_return( foo: "bar" )
    end

    it 'adds the branch to the query params' do
      out = faraday.call(env)
      out[:url].query.should eql("foo=bar")
    end
  end

  context 'no branch present' do

    it 'does not add the branch to the query params' do
      out = faraday.call(env)
      out[:url].query.should be_nil
    end
  end
end
