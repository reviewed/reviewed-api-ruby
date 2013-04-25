require 'reviewed/attachment'

module Reviewed
  class Product < Base

    extend Forwardable
      def_delegators :primary_variant, :manufacturer_specs, :attachments

    has_many :awards
    has_one  :brand
    has_many :variants

    def primary_variant
      if primary_variant_id
        fetch_variant(primary_variant_id)
      end
    end

    def fetch_variant(id, params={})
      Request.new(resource: Variant).find(id, params)
    end
  end
end
