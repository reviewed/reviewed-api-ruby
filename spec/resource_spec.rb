require 'spec_helper.rb'

describe Reviewed::Resource do
  use_vcr_cassette 'resource/generic'

  before(:each) do
    @response = Reviewed::Resource.get('authors')
  end

  it 'returns a valid response' do
    @response.json["pagination"]["total"].should eql(173)
  end
end
