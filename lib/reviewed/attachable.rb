module Reviewed
  module Attachable

    def attachments opts={}
      tags = opts.has_key?(:tags) ? [opts[:tags]].flatten : []
      attachments = []

      if tags.present?
        defaults = default_attachments & tags # attachments that already exist
        fetch = tags - defaults # attachments we need to fetch

        if defaults.present?
          tags.each do |tag|
            attachments <<  attributes['attachments'].select { |x| x.tags.include?(tag.to_s) }
          end
        end

        if fetch.present?
          attachments << fetch_attachments(opts.merge!(tags: fetch))
        end
      else
        attachments = fetch_attachments(opts).to_a
      end

      return attachments.flatten.uniq.compact
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
