require 'spec_helper'

describe Reviewed::Product do
  describe 'attachments' do
    use_vcr_cassette 'product/attachments'

    before(:each) do
      @product = Reviewed::Product.find('minden-master-ii')
    end

    it 'returns all attachments' do
      @product.attachments.length.should == 1
    end

    it 'finds attachments by tag' do
      attachments = @product.attachments('vanity')
      attachments.length.should == 1
      attachments.each do |attachment|
        attachment.tags.join(',').should match(/vanity/i)
      end
    end

    it 'does not have any matching attachments' do
      attachments = @product.attachments('doesnotcompute')
      attachments.length.should == 0
    end
  end
end
