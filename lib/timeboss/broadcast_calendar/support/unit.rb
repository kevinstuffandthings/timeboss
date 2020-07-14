# frozen_string_literal: true
module TimeBoss
  module BroadcastCalendar
    module Support
      module Unit
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

        %w[month quarter half year].each do |period|
          define_method period.pluralize do
            BroadcastCalendar.send("#{period.pluralize}_for", self)
          end
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
