# frozen_string_literal: true
require_relative './navigable'
require_relative './shiftable'
require_relative './formatter'

module TimeBoss
  class Calendar
    module Support
      class Unit
        include Navigable
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

        # Is the specified unit equal to this one, based on its unit type and date range?
        # @param entry [Unit] the unit to compare
        # @return [Boolean] true when periods are equal
        def ==(entry)
          self.class == entry.class && self.start_date == entry.start_date && self.end_date == entry.end_date
        end

        # Format this period based on specified granularities.
        # @param periods [Array<Symbol, String>] the periods to include (`half, week`, or `quarter`)
        # @return [String] (e.g. "2020H2W7" or "2020Q3")
        def format(*periods)
          Formatter.new(self, periods.presence || Formatter::PERIODS).to_s
        end

        # Starting from this unit of time, build a period extending through the specified time unit.
        # @param unit [Unit] the period to extend through
        # @return [Period]
        def thru(unit)
          Period.new(calendar, self, unit)
        end

        # Does this period cover the current date?
        # @return [Boolean]
        def current?
          Date.today.between?(start_date, end_date)
        end

        # Return the unit relative to this one by the specified offset.
        # Offset values can be positive or negative.
        # @param value [Integer]
        # @return [Unit]
        def offset(value)
          method = value.negative? ? :previous : :next
          base = self
          value.abs.times { base = base.send(method) }
          base
        end

        # Move some number of units forward from this unit.
        # @param value [Integer]
        # @return [Unit]
        def +(value)
          offset(value)
        end

        # Move some number of units backward from this unit.
        # @param value [Integer]
        # @return [Unit]
        def -(value)
          offset(-value)
        end

        # Express this period as a date range.
        # @return [Range<Date, Date>]
        def to_range
          @_to_range ||= start_date .. end_date
        end
      end
    end
  end
end
