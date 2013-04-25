require 'spec_helper'

describe Reviewed::Product do

  let(:product) do
    client.products.find('mark-of-the-ninja')
  end

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  describe 'associations' do

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
    let(:variant) { {} }
    before(:each) { product.stub!(:primary_variant).and_return(variant) }

    it "delegates :manufacturer_specs" do
      variant.should_receive(:manufacturer_specs)
      product.manufacturer_specs
    end

    it "delegates :attachments" do
      product.primary_variant.should_receive(:attachments).with('hero')
      product.send(:attachments, 'hero')
    end
  end

  describe 'fetch_variant', vcr: true do
    it "fetches a variant" do
      v = product.variant_ids.first
      p = product.fetch_variant(v)
      p.should be_an_instance_of(Reviewed::Variant)
    end
  end
end
