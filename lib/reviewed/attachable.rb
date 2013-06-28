module Reviewed
  module Attachable

    def self.included(base)
      base.const_set(:DEFAULT_ATTACHMENTS, []) unless defined?(base::DEFAULT_ATTACHMENTS)
    end

    def attachments tag=nil, opts={}
      if self.class::DEFAULT_ATTACHMENTS.include?(tag.to_s) && attributes['attachments'].is_a?(Array)
        return attributes['attachments'].select { |x| x.tags.include?(tag.to_s) }
      else
        fetch_attachments(opts.merge!(tags: tag)).to_a
      end
    end

    def gallery tags=nil, num=8, page=1
      fetch_attachments tags: tags, :gallery => true, :per_page => num, :page => page, :order => 'priority'
    end

    private

    def fetch_attachments opts={}
      req = Request.new :resource => Attachment, :scope => self
      req.where opts
    end
  end
end
