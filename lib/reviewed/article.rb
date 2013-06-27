require 'reviewed/page'
require 'reviewed/product'
require 'reviewed/attachment'
require 'reviewed/deal'

module Reviewed
  class Article < Base
    DEFAULT_ATTACHMENTS = ['hero']

    has_attachments

    has_many :pages
    has_many :products
    has_many :deals
    has_many :related_articles, class_name: "Reviewed::Article"

    def find_page(slug)
      pages.find { |page| page.slug.match(/#{slug}/i) }
    end

    def primary_product
      if respond_to?(:products)
        products.select { |p| p.id == primary_product_id }.first
      end
    end

  end
end
