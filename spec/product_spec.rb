require 'spec_helper'

describe Reviewed::Product do

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  describe 'associations' do

    describe 'attachments', vcr: true do

      before(:each) do
        Reviewed::Cache.store.clear
        @product = client.products.with_no_cache.find('minden-master-ii')
      end

      it 'no longer has_many :attachments' do
        Reviewed::Product._embedded_many.should_not include({"attachments"=>"Reviewed::Attachment"})
      end

      it 'returns attachments of the correct class' do
        @product.attachments(tags: 'gallery').each do |attachment|
          attachment.should be_an_instance_of(Reviewed::Attachment)
        end
      end

      it 'returns attachments by tag' do
        @product.attachments(tags: 'vanity').length.should == 1
      end

      it 'matches attachments by tag properly' do
        attachments = @product.attachments(tags: 'vanity')
        attachments.each do |attachment|
          attachment.tags.join(',').should match(/vanity/i)
        end
      end

      it 'does not have any matching attachments' do
        attachments = @product.attachments(tags: 'doesnotcompute')
        attachments.length.should == 0
      end
    end
  end

  describe 'manufacturer_specs', vcr: true do

    before(:each) do
      @product = client.products.find('minden-master-ii')
    end

    it 'has_many :manufacturer_specs' do
      Reviewed::Product._embedded_many.should include({"manufacturer_specs"=>"Reviewed::ManufacturerSpec"})
    end

    it 'returns attachments of the correct class' do
      @product.manufacturer_specs.each do |ms|
        ms.should be_an_instance_of(Reviewed::ManufacturerSpec)
      end
    end
  end
end
