# frozen_string_literal: true

require_relative "./navigable"
require_relative "./translatable"
require_relative "./shiftable"
require_relative "./formatter"

module TimeBoss
  class Calendar
    module Support
      class Unit
        include Navigable
        include Translatable
        include Shiftable
        attr_reader :calendar, :start_date, :end_date

        UnsupportedUnitError = Class.new(StandardError)

        def self.type
          name.demodulize.underscore
        end

        def initialize(calendar, start_date, end_date)
          @calendar = calendar
          @start_date = start_date
          @end_date = end_date
        end

        # Is the specified unit equal to this one, based on its unit type and date range?
        # @param entry [Unit] the unit to compare
        # @return [Boolean] true when periods are equal
        def ==(other)
          self.class == other.class && start_date == other.start_date && end_date == other.end_date
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
          value.abs.times { base = base.public_send(method) }
          base
        end

        # Move some number of units forward from this unit.
        # @param value [Integer]
        # @return [Unit]
        def +(other)
          offset(other)
        end

        # Move some number of units backward from this unit.
        # @param value [Integer]
        # @return [Unit]
        def -(other)
          offset(-other)
        end

        # Express this period as a date range.
        # @return [Range<Date, Date>]
        def to_range
          @_to_range ||= start_date..end_date
        end

        # Clamp this unit to the range of the provided unit.
        # @return [Period]
        def clamp(unit)
          new_start_date = start_date.clamp(unit.start_date, unit.end_date)
          new_end_date = end_date.clamp(unit.start_date, unit.end_date)
          return unless new_start_date.between?(start_date, end_date) && new_end_date.between?(start_date, end_date)
          calendar.parse("#{new_start_date}..#{new_end_date}")
        end

        def inspect
          "#<#{self.class.name} start_date=#{start_date}, end_date=#{end_date}>"
        end

        protected

        def dates
          @_dates ||= to_range.to_a
        end
      end
    end
  end
end
