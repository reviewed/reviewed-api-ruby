require 'spec_helper.rb'

describe Faraday::Branches do

  class FauxApp
    def call(env)
      return env
    end
  end

  let(:faraday) { Faraday::Branches.new(FauxApp.new) }

  context 'Articles' do

    let(:env) { { url: URI.parse("http://www.the-guide-staging.com/api/v1/articles") } }

    context 'branch present' do

      before(:each) do
        Reviewed::Article.stub!(:branch).and_return("test")
      end

      it 'adds the branch to the query params' do
        out = faraday.call(env)
        out[:url].query.should eql("branch=test")
      end
    end

    context 'no branch present' do

      it 'does not add the branch to the query params' do
        out = faraday.call(env)
        out[:url].query.should be_nil
      end
    end
  end

  context 'Others' do

    let(:env) { { url: URI.parse("http://www.the-guide-staging.com/api/v1/products") } }

    context 'branch present' do

      before(:each) do
        Reviewed::Article.stub!(:branch).and_return("test")
      end

      it 'adds the branch to the query params' do
        out = faraday.call(env)
        out[:url].query.should eql(nil)
      end
    end

    context 'no branch present' do

      it 'does not add the branch to the query params' do
        out = faraday.call(env)
        out[:url].query.should be_nil
      end
    end
  end
end
