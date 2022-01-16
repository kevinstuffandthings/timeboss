# frozen_string_literal: true

require_relative "./unit"

module TimeBoss
  class Calendar
    module Support
      class MonthlyUnit < Unit
        attr_reader :year_index, :index

        def initialize(calendar, year_index, index, start_date, end_date)
          super(calendar, start_date, end_date)
          @year_index = year_index
          @index = index
        end

        # Get a stringified representation of this unit.
        # @return [String] (e.g. "2020Q3: 2020-06-29 thru 2020-09-27")
        def to_s
          "#{name}: #{start_date} thru #{end_date}"
        end

        # Get a list of weeks contained within this period.
        # @return [Array<Week>]
        def weeks
          raise UnsupportedUnitError unless calendar.supports_weeks?
          base = calendar.year(year_index)
          calendar.weeks_in(year: base).select { |w| (w.dates & dates).count >= 4 }
        end

        private

        def max_index
          12 / self.class::NUM_MONTHS
        end

        def up
          if index == max_index
            calendar.public_send(self.class.type, year_index + 1, 1)
          else
            calendar.public_send(self.class.type, year_index, index + 1)
          end
        end

        def down
          if index == 1
            calendar.public_send(self.class.type, year_index - 1, max_index)
          else
            calendar.public_send(self.class.type, year_index, index - 1)
          end
        end
      end
    end
  end
end
