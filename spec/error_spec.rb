require 'spec_helper.rb'

describe Reviewed do

  describe Reviewed::ResourceNotFound do
    it 'should respond to url' do
      error = Reviewed::ResourceNotFound.new(url: 'url', msg: "msg")
      error.url.should eql('url')
      error.message.should eql('msg')
    end
  end

  describe Reviewed::ApiError do
    it "sets a status code" do
      e = Reviewed::ApiError.new(msg: "Fail hard", http_status: 1000)
      e.http_status.should eql(1000)
    end
  end
end
