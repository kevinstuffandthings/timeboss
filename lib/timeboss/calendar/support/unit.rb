# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Support
      class Unit
        attr_reader :calendar

        def initialize(calendar)
          @calendar = calendar
        end

        def ==(entry)
          self.class == entry.class && self.start_date == entry.start_date && self.end_date == entry.end_date
        end

        def current?
          Date.today.between?(start_date, end_date)
        end

        def offset(value)
          method = value.negative? ? :previous : :next
          base = self
          value.abs.times { base = base.send(method) }
          base
        end

        def days
          range.to_a.map { |d| Day.new(d) }
        end

        %w[week month quarter half year].each do |period|
          define_method period.pluralize do
            calendar.send("#{period.pluralize}_for", self)
          end

          define_method period do
            entries = send(period.pluralize)
            return nil unless entries.length == 1
            entries.first
          end
        end

        def day
          start_date if start_date == end_date
        end

        def +(value)
          offset(value)
        end

        def -(value)
          offset(-value)
        end
      end
    end
  end
end
