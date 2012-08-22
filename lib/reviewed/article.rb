module Reviewed
  class Article < Base
    def find_page(slug)
      pages.find { |page| page.slug.match(/#{slug}/i) }
    end
  end
end
