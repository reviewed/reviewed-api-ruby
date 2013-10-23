require 'reviewed/article'

module Reviewed
  class Award < Base
    has_many :articles
  end
end
