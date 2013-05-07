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

      it 'images of the propery tag type' do
        Reviewed::Request.any_instance.should_receive(:where).with(tags: :gallery)
        attachments = variant.attachments(:gallery, {})
      end
    end
  end
end
