require 'spec_helper'

describe Reviewed::Util do
  describe 'build request headers' do
    before(:each) do
      @headers = Reviewed::Util.build_request_headers(extra: 1)
    end

    it 'sets the authorization header' do
      @headers['X-Reviewed-Authorization'].should == Reviewed.api_key
    end

    it 'sets the accept header' do
      @headers['accept'].should == 'json'
    end

    it 'sets additional headers' do
      @headers['extra'].should == 1
    end
  end

  describe 'build query string' do
    it 'includes a single key/value pair' do
      str = Reviewed::Util.build_query_string(name: 'test')
      str.should == 'name=test'
    end

    it 'includes multiple key/value pairs' do
      str = Reviewed::Util.build_query_string(name: 'test', page: 1)
      str.should == 'name=test&page=1'
    end
  end
end
