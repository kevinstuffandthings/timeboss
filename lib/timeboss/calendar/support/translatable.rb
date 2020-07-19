# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Support
      module Translatable
        PERIODS = %w[day week month quarter half year]

        PERIODS.each do |period|
          periods = period.pluralize

          define_method(periods) { calendar.send("#{periods}_for", self) }

          define_method(period) do
            entries = send(periods)
            return nil unless entries.length == 1
            entries.first
          end
        end

        #
        # i hate this
        #

        ### Days

        # @!method days
        # Get a list of days that fall within this unit.
        # @return [Array<Calendar::Day>]

        # @!method day
        # Get the day this unit represents.
        # Returns nil if no single day can be identified.
        # @return [Array<Calendar::Day>, nil]

        ### Weeks

        # @!method weeks
        # Get a list of weeks that fall within this unit.
        # @return [Array<Calendar::Week>]

        # @!method week
        # Get the week this unit represents.
        # Returns nil if no single week can be identified.
        # @return [Array<Calendar::Week>, nil]

        ### Months

        # @!method months
        # Get a list of months that fall within this unit.
        # @return [Array<Calendar::Month>]

        # @!method month
        # Get the month this unit represents.
        # Returns nil if no single month can be identified.
        # @return [Array<Calendar::Month>, nil]

        ### Quarters

        # @!method quarters
        # Get a list of quarters that fall within this unit.
        # @return [Array<Calendar::Quarter>]

        # @!method quarter
        # Get the quarter this unit represents.
        # Returns nil if no single quarter can be identified.
        # @return [Array<Calendar::Quarter>, nil]

        ### Halves

        # @!method halves
        # Get a list of halves that fall within this unit.
        # @return [Array<Calendar::Half>]

        # @!method half
        # Get the half this unit represents.
        # Returns nil if no single half can be identified.
        # @return [Array<Calendar::Half>, nil]

        ### Years

        # @!method years
        # Get a list of years that fall within this unit.
        # @return [Array<Calendar::Year>]

        # @!method year
        # Get the year this unit represents.
        # Returns nil if no single year can be identified.
        # @return [Array<Calendar::Year>, nil]
      end
    end
  end
end
