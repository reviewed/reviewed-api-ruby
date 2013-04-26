module Reviewed
  module Attachable

    def attachments tag, opts={}
      (@attachments ||= {})[tag] ||= fetch_attachments tag, opts
    end

    def gallery tags=nil, num=8, page=1
      fetch_attachments tags, :gallery => true, :per_page => num, :page => page, :order => 'priority'
    end

    private

    def fetch_attachments tag, opts={}
      params = opts.merge :tags => tag
      req = Request.new :resource => Attachment, :scope => self
      req.where params
    end

  end
end
