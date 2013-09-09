module Reviewed
  module Attachable

    def attachments tag=nil, opts={}
      if default_attachments.include?(tag.to_s)
        return attributes['attachments'].select { |x| x.tags.include?(tag.to_s) }
      else
        fetch_attachments(opts.merge!(tags: tag)).to_a
      end
    end

    def gallery tags=nil, num=8, page=1
      fetch_attachments tags: tags, :gallery => true, :per_page => num, :page => page, :order => 'priority'
    end

    private

    def default_attachments
      attributes['attachments'] ||= []
      attributes['attachments'].map(&:tags).flatten.uniq.compact
    end

    def fetch_attachments opts={}
      req = client.attachments(scope: self)
      req.where opts
    end
  end
end
