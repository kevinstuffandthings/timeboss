# frozen_string_literal: true
require_relative './shiftable'
require_relative './formatter'

module TimeBoss
  class Calendar
    module Support
      class Unit
        include Shiftable
        attr_reader :calendar, :start_date, :end_date

        def self.type
          self.name.demodulize.underscore
        end

        def initialize(calendar, start_date, end_date)
          @calendar = calendar
          @start_date = start_date
          @end_date = end_date
        end

        def ==(entry)
          self.class == entry.class && self.start_date == entry.start_date && self.end_date == entry.end_date
        end

        def format(*periods)
          Formatter.new(self, periods.presence || Formatter::PERIODS).to_s
        end

        def thru(unit)
          Period.new(calendar, self, unit)
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

        def +(value)
          offset(value)
        end

        def -(value)
          offset(-value)
        end

        def to_range
          @_to_range ||= start_date .. end_date
        end
      end
    end
  end
end
