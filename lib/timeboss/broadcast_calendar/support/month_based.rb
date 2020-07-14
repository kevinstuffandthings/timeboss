require_relative './has_navigation'

module TimeBoss
  module BroadcastCalendar
    module Support
      class MonthBased
        include Support::HasNavigation
        attr_reader :year, :index, :start_date, :end_date

        def self.type
          self.name.demodulize.underscore
        end

        def initialize(year, index, start_date, end_date)
          @year = year
          @index = index
          @start_date = start_date
          @end_date = end_date
        end

        def next
          if index == max_index
            TimeBoss::BroadcastCalendar.send(self.class.type, year + 1, 1)
          else
            TimeBoss::BroadcastCalendar.send(self.class.type, year, index + 1)
          end
        end

        def previous
          if index == 1
            TimeBoss::BroadcastCalendar.send(self.class.type, year - 1, max_index)
          else
            TimeBoss::BroadcastCalendar.send(self.class.type, year, index - 1)
          end
        end

        def range
          start_date..end_date
        end

        def to_s
          "#{name}: #{start_date} thru #{end_date}"
        end

        def weeks
          num_weeks = (((end_date - start_date) + 1) / 7.0).to_i
          num_weeks.times.map { |i| Week.new(self, i + 1, start_date + (i * 7).days, start_date + ((i * 7) + 6).days) }
        end

        private

        def max_index
          12 / self.class::NUM_MONTHS
        end
      end
    end
  end
end
