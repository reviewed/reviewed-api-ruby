module Reviewed
  class Website < Base

    def self.all
      where({:per_page=>"all"})
    end
  end
end
