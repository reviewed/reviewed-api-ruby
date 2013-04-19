require 'reviewed/attachment'

module Reviewed
  class Product < Base

    extend Forwardable
      def_delegator :primary_variant, :manufacturer_specs

    has_many :attachments
    has_many :awards
    has_one  :brand
    has_many :variants

    def attachments(tag=nil)
      if tag.present?
        @attributes.attachments.select do |attachment|
          attachment_tags = attachment.tags || []
          attachment_tags.map(&:downcase).include?(tag.downcase)
        end
      else
        @attributes.attachments
      end
    end

    def primary_variant
      if respond_to?(:variants)
        variants.select { |v| v.id == primary_variant_id }.first
      end
    end
  end
end
