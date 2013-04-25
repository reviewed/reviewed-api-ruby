require 'spec_helper'

describe Reviewed::Variant do

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end
  let(:product) { client.products.find('mark-of-the-ninja') }
  let(:variant) { product.primary_variant }

  describe 'associations' do

    describe 'manufacturer_specs' do

      it 'has_many :manufacturer_specs' do
        Reviewed::Variant._embedded_many.should include({"manufacturer_specs"=>Reviewed::ManufacturerSpec})
      end
    end

    describe 'attachments', vcr: true do

      it 'returns attachments of the correct class' do
        product.attachments(:gallery).each do |attachment|
          attachment.should be_an_instance_of(Reviewed::Attachment)
        end
      end

      it 'matches attachments by tag properly' do
        attachments = product.attachments('vanity')
        attachments.length.should == 1
        attachments.each do |attachment|
          attachment.tags.join(',').should match(/vanity/i)
        end
      end

      it 'does not have any matching attachments' do
        attachments = product.attachments('doesnotcompute')
        attachments.length.should == 0
      end
    end
  end
end
