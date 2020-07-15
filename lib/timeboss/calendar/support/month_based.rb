# frozen_string_literal: true
require_relative './unit'

module TimeBoss
  class Calendar
    module Support
      class MonthBased < Unit
        attr_reader :year, :index, :start_date, :end_date

        def self.type
          self.name.demodulize.underscore
        end

        def initialize(calendar, year, index, start_date, end_date)
          super(calendar)
          @year = year
          @index = index
          @start_date = start_date
          @end_date = end_date
        end

        def next
          if index == max_index
            calendar.send(self.class.type, year + 1, 1)
          else
            calendar.send(self.class.type, year, index + 1)
          end
        end

        def previous
          if index == 1
            calendar.send(self.class.type, year - 1, max_index)
          else
            calendar.send(self.class.type, year, index - 1)
          end
        end

        def range
          start_date..end_date
        end

        def to_s
          "#{name}: #{start_date} thru #{end_date}"
        end

        def weeks
          base = calendar.year(year)
          num_weeks = (((base.end_date - base.start_date) + 1) / 7.0).to_i
          num_weeks.times.map { |i| Week.new(calendar, year, i + 1, base.start_date + (i * 7).days, base.start_date + ((i * 7) + 6).days) }
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
