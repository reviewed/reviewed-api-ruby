module Reviewed
  class Deal < Base
    def to_s
      "\#<#{self.class}:#{self.affiliate_link}>"
    end
  end
end
