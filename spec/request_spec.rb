require 'spec_helper.rb'

describe Reviewed::Request do
  describe 'generic' do
    use_vcr_cassette 'request/authors'

    before(:each) do
      @response = Reviewed::Request.get('authors')
    end

    it 'returns a valid response' do
      @response.json["pagination"]["total"].should eql(172)
    end
  end
end
