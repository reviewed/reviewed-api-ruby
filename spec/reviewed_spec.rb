require 'spec_helper.rb'

describe Reviewed do

  describe 'errors' do

    it 'should respond to url' do
      error = Reviewed::ResourceNotFound.new(url: 'url', msg: "msg")
      error.url.should eql('url')
      error.message.should eql('msg')
    end
  end
end
