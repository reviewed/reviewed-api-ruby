require 'spec_helper'

describe Reviewed::Variant do

  let(:product) { client.products.find('minden-master-ii') }
  let(:variant) { product.primary_variant }

  describe 'associations' do

    it 'has_many :manufacturer_specs' do
      Reviewed::Variant._embedded_many.should include({"manufacturer_specs"=>Reviewed::ManufacturerSpec})
    end
  end
end
