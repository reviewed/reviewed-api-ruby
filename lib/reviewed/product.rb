require 'reviewed/attachment'

module Reviewed
  class Product < Base
    has_many :attachments
    has_many :manufacturer_specs
    has_many :awards
    has_one  :brand

    def attachments tag
      (@attachments ||= {})[tag] ||= fetch_attachments tag
    end

    def gallery num=8, page=1
      fetch_attachments 'gallery', :per_page => num, :page => page, :order => 'priority'
    end

    private

    def fetch_attachments tag, opts={}
      params = opts.merge :tags => tag
      req = Reviewed::Request.new :resource => Attachment, :path => "products/#{id}/attachments"
      req.where params
    end

  end
end
