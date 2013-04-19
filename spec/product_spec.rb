require 'spec_helper'

describe Reviewed::Product do

  let(:product) { client.products.find('minden-master-ii') }

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  describe 'associations' do

    describe 'attachments', vcr: true do

      before(:each) do
        @product = client.products.find('minden-master-ii')
      end

      it 'no longer has_many :attachments' do
        Reviewed::Product._embedded_many.should_not include({"attachments"=>Reviewed::Attachment})
      end

      it 'returns attachments of the correct class' do
        @product.attachments(:gallery).each do |attachment|
          attachment.should be_an_instance_of(Reviewed::Attachment)
        end
      end

      it 'returns attachments by tag' do
        @product.attachments(:vanity).length.should == 1
      end

      it 'matches attachments by tag properly' do
        attachments = @product.attachments('vanity')
        attachments.each do |attachment|
          attachment.tags.join(',').should match(/vanity/i)
        end
      end

      it 'does not have any matching attachments' do
        attachments = product.attachments('doesnotcompute')
        attachments.length.should == 0
      end
    end

    describe 'manufacturer_specs', vcr: true do

      before(:each) do
        product = client.products.find('minden-master-ii')
      end

      it 'returns attachments of the correct class' do
        product.manufacturer_specs.each do |ms|
          ms.should be_an_instance_of(Reviewed::ManufacturerSpec)
        end
      end
    end
  end

  describe '#primary_variant', vcr: true do

    it 'returns the primary_variant' do
      product.primary_variant.is_primary_variant.should be_true
    end

    it 'returns a Reviewed::Variant model' do
      product.primary_variant.should be_an_instance_of(Reviewed::Variant)
    end
  end

  describe 'delegations', vcr: true do

    [:manufacturer_specs].each do |method|
      describe method do
        it 'delegates to the primary variant' do
          product.primary_variant.should_receive(method)
          product.send(method)
        end
      end
    end
  end
end
