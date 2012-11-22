require 'spec_helper'

describe Reviewed::Product do

  describe 'associations' do

    describe 'attachments' do
      use_vcr_cassette 'product/attachments'

      before(:each) do
        @product = Reviewed::Product.find('minden-master-ii')
      end

      it 'has_many :attachments' do
        Reviewed::Product._embedded_many.should include({"attachments"=>Reviewed::Attachment})
      end

      it 'returns attachments of the correct class' do
        @product.attachments.each do |attachment|
          attachment.should be_an_instance_of(Reviewed::Attachment)
        end
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
end
