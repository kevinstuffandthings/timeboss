# frozen_string_literal: true
require_relative './unit'

module TimeBoss
  class Calendar
    module Support
      class MonthBased < Unit
        attr_reader :year_index, :index, :start_date, :end_date

        def initialize(calendar, year_index, index, start_date, end_date)
          super(calendar)
          @year_index = year_index
          @index = index
          @start_date = start_date
          @end_date = end_date
        end

        def next
          if index == max_index
            calendar.send(self.class.type, year_index + 1, 1)
          else
            calendar.send(self.class.type, year_index, index + 1)
          end
        end

        def previous
          if index == 1
            calendar.send(self.class.type, year_index - 1, max_index)
          else
            calendar.send(self.class.type, year_index, index - 1)
          end
        end

        def range
          start_date..end_date
        end

        def to_s
          "#{name}: #{start_date} thru #{end_date}"
        end

        def weeks
          base = calendar.year(year_index)
          num_weeks = (((base.end_date - base.start_date) + 1) / 7.0).to_i
          num_weeks.times.map { |i| Week.new(calendar, year_index, i + 1, base.start_date + (i * 7).days, base.start_date + ((i * 7) + 6).days) }
                         .select { |w| w.start_date.between?(start_date, end_date) }
        end

        private

        def max_index
          12 / self.class::NUM_MONTHS
        end
      end
    end
  end
end
