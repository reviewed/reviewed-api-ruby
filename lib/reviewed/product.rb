require 'reviewed/attachment'

module Reviewed
  class Product < Base
    DEFAULT_ATTACHMENTS = ['vanity', 'hero']

    has_attachments
    has_many :manufacturer_specs
    has_many :awards
    has_one  :brand

  end
end
