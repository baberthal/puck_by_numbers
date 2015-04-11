module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def sit_filter(sit_filter)
      if sit_filter
        where(situation: sit_filter)
      else
        where(situation: 1)
      end
    end
  end

end
