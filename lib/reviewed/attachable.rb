module Reviewed
  module Attachable

    def attachments tag=nil, opts={}
      if tag.nil?
        tagged = fetch_attachments
      else
        tagged = select_attachments(tag)
        tagged = fetch_attachments(tags: tag) if tagged.empty?
      end
      return tagged
    end

    def gallery tags=nil, num=8, page=1
      fetch_attachments tags: tags, :gallery => true, :per_page => num, :page => page, :order => 'priority'
    end

    private

    def select_attachments tag
      attributes['attachments'].select { |x| x.tags.include?(tag) }
    end

    def fetch_attachments opts={}
      req = Request.new :resource => Attachment, :scope => self
      collection = req.where opts
      attributes.attachments += collection.to_a
      collection.to_a
    end
  end
end
