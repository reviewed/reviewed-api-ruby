require 'reviewed/attachment'

module Reviewed
  class Product < Base

    has_attachments
    has_many :manufacturer_specs
    has_many :awards
    has_one  :brand

  end
end
