ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural 'hero', 'heroes'
  inflect.singular 'heroes', 'hero'
end

module Reviewed
  class Hero < Base
    def to_s
      "\#<#{self.class.name}:#{self.object_id}>"
    end
  end
end
