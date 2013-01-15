require 'spec_helper'

describe Reviewed::Product do

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  describe 'associations' do

    describe 'attachments', vcr: true do

      before(:each) do
        @product = client.products.find('minden-master-ii')
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

  describe 'manufacturer_specs', vcr: true do

    before(:each) do
      @product = client.products.find('minden-master-ii')
    end

    it 'has_many :manufacturer_specs' do
      Reviewed::Product._embedded_many.should include({"manufacturer_specs"=>Reviewed::ManufacturerSpec})
    end

    it 'returns attachments of the correct class' do
      @product.manufacturer_specs.each do |ms|
        ms.should be_an_instance_of(Reviewed::ManufacturerSpec)
      end
    end
  end
end
