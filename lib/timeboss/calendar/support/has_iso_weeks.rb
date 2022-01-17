# frozen_string_literal: true

module TimeBoss
  class Calendar
    module Support
      module HasIsoWeeks
        def weeks_in(year:)
          weeks = []
          start_date = Date.commercial(year.year_index)
          end_date = Date.commercial(year.next.year_index)
          while start_date < end_date
            weeks << Week.new(self, start_date, start_date + 6.days)
            start_date += 7.days
          end
          weeks
        end

        class Week < Calendar::Week
          def index
            start_date.cweek
          end

          def year
            calendar.year(start_date.cwyear)
          end
        end
      end
    end
  end
end
