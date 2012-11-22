require 'reviewed/attachment'

module Reviewed
  class Product < Base
    has_many :attachments

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
