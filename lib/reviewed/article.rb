require 'reviewed/page'
require 'reviewed/product'
require 'reviewed/attachment'

module Reviewed
  class Article < Base
    has_many :pages
    has_many :products
    has_many :attachments

    def find_page(slug)
      pages.find { |page| page.slug.match(/#{slug}/i) }
    end

    def primary_product
      if respond_to?(:products)
        products.select { |p| p.id == primary_product_id }.first
      end
    end

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
  end
end
