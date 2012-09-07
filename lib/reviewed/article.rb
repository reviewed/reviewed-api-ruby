module Reviewed
  class Article < Base
    def find_page(slug)
      pages.find { |page| page.slug.match(/#{slug}/i) }
    end

    def attachments(tag=nil)
      if tag.present?
        @attributes[:attachments].select do |attachment|
          attachment_tags = attachment.tags || []
          attachment_tags.map(&:downcase).include?(tag.downcase)
        end
      else
        @attributes[:attachments]
      end
    end
  end
end
