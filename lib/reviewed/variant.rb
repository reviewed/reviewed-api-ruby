module Reviewed
  class Variant < Base
    has_attachments
    has_many :manufacturer_specs
  end
end
