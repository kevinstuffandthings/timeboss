# frozen_string_literal: true

module TimeBoss
  class Calendar
    module Support
      module Clampable
        # Clamp this unit to the range of the provided unit.
        # @return [Period]
        def clamp(unit)
          new_start_date = start_date.clamp(unit.start_date, unit.end_date)
          new_end_date = end_date.clamp(unit.start_date, unit.end_date)
          return unless new_start_date.between?(start_date, end_date) && new_end_date.between?(start_date, end_date)
          calendar.parse("#{new_start_date}..#{new_end_date}")
        end
      end
    end
  end
end
