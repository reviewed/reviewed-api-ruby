require 'spec_helper.rb'

describe Reviewed::Response do

  describe "response" do
    use_vcr_cassette 'request/authors'

    before(:each) do
      @response = Reviewed::Request.get('authors')
    end

    describe "json" do

      it 'returns json' do
        @response.json[:pagination]["total"].should eql(171)
      end
    end

    describe "raw" do

      it 'returns the raw_response' do
        @response.raw.should be_an_instance_of(String)
      end
    end
  end
end
