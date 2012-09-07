require 'spec_helper'

describe Reviewed::Product do
  describe 'attachments' do
    use_vcr_cassette 'product/attachments'

    before(:each) do
      @product= Reviewed::Product.find('medium-green-charcoal')
    end

    it 'returns all attachments' do
      @product.attachments.length.should > 1
    end

    it 'finds attachments by tag' do
      attachments = @product.attachments('hero')
      attachments.length.should == 1
      attachments.each do |attachment|
        attachment.tags.join(',').should match(/hero/i)
      end
    end
  end
end
