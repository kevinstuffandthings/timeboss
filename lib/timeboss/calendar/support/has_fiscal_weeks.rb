# frozen_string_literal: true

module TimeBoss
  class Calendar
    module Support
      module HasFiscalWeeks
        def weeks_in(year:)
          num_weeks = (((year.end_date - year.start_date) + 1) / 7.0).to_i
          num_weeks.times.map do |i|
            start_date = year.start_date + (i * 7).days
            Week.new(self, start_date, start_date + 6.days)
          end
        end
      end
    end
  end
end
