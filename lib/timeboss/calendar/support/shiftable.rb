# frozen_string_literal: true

module TimeBoss
  class Calendar
    module Support
      module Shiftable
        Support::Translatable::PERIODS.each do |period|
          periods = period.pluralize

          define_method("in_#{period}") do
            base = public_send(periods)
            return unless base.length == 1
            base.first.public_send(self.class.type.to_s.pluralize).find_index { |p| p == self } + 1
          end

          define_method("#{periods}_ago") do |offset|
            (base_offset = public_send("in_#{period}")) || return
            (calendar.public_send("this_#{period}") - offset).public_send(self.class.type.to_s.pluralize)[base_offset - 1]
          end

          define_method("#{periods}_ahead") { |o| public_send("#{periods}_ago", o * -1) }

          define_method("last_#{period}") { public_send("#{periods}_ago", 1) }
          define_method("this_#{period}") { public_send("#{periods}_ago", 0) }
          define_method("next_#{period}") { public_send("#{periods}_ahead", 1) }
        end

        alias_method :yesterday, :last_day
        alias_method :today, :this_day
        alias_method :tomorrow, :next_day

        #
        # i hate this
        #

        ### Days

        # @!method in_day
        # Get the index within the day that this unit falls in.
        # Returns nil if no single day can be identified.
        # @return [Integer, nil]

        # @!method days_ago
        # Get the index-relative day some number of days ago.
        # Returns nil if no single day can be identified.
        # @param offset [Integer] the number of days back to shift this period
        # @return [Calendar::Day, nil]

        # @!method days_ahead
        # Get the index-relative day some number of days ahead.
        # Returns nil if no single day can be identified.
        # @param offset [Integer] the number of days forward to shift this period
        # @return [Calendar::Day, nil]

        # @!method last_day
        # Get the index-relative day 1 day ago.
        # Returns nil if no single day can be identified.
        # @return [Calendar::Day, nil]

        # @!method this_day
        # Get the index-relative day for this day.
        # Returns nil if no single day can be identified.
        # @return [Calendar::Day, nil]

        # @!method next_day
        # Get the index-relative day 1 day forward.
        # Returns nil if no single day can be identified.
        # @return [Calendar::Day, nil]

        ### Weeks

        # @!method in_week
        # Get the index within the week that this unit falls in.
        # Returns nil if no single week can be identified.
        # @return [Integer, nil]

        # @!method weeks_ago
        # Get the index-relative week some number of weeks ago.
        # Returns nil if no single week can be identified.
        # @param offset [Integer] the number of weeks back to shift this period
        # @return [Calendar::Week, nil]

        # @!method weeks_ahead
        # Get the index-relative week some number of weeks ahead.
        # Returns nil if no single week can be identified.
        # @param offset [Integer] the number of weeks forward to shift this period
        # @return [Calendar::Week, nil]

        # @!method last_week
        # Get the index-relative week 1 week ago.
        # Returns nil if no single week can be identified.
        # @return [Calendar::Week, nil]

        # @!method this_week
        # Get the index-relative week for this week.
        # Returns nil if no single week can be identified.
        # @return [Calendar::Week, nil]

        # @!method next_week
        # Get the index-relative week 1 week forward.
        # Returns nil if no single week can be identified.
        # @return [Calendar::Week, nil]

        ### Months

        # @!method in_month
        # Get the index within the month that this unit falls in.
        # Returns nil if no single month can be identified.
        # @return [Integer, nil]

        # @!method months_ago
        # Get the index-relative month some number of months ago.
        # Returns nil if no single month can be identified.
        # @param offset [Integer] the number of months back to shift this period
        # @return [Calendar::Month, nil]

        # @!method months_ahead
        # Get the index-relative month some number of months ahead.
        # Returns nil if no single month can be identified.
        # @param offset [Integer] the number of months forward to shift this period
        # @return [Calendar::Month, nil]

        # @!method last_month
        # Get the index-relative month 1 month ago.
        # Returns nil if no single month can be identified.
        # @return [Calendar::Month, nil]

        # @!method this_month
        # Get the index-relative month for this month.
        # Returns nil if no single month can be identified.
        # @return [Calendar::Month, nil]

        # @!method next_month
        # Get the index-relative month 1 month forward.
        # Returns nil if no single month can be identified.
        # @return [Calendar::Month, nil]

        ### Quarters

        # @!method in_quarter
        # Get the index within the quarter that this unit falls in.
        # Returns nil if no single quarter can be identified.
        # @return [Integer, nil]

        # @!method quarters_ago
        # Get the index-relative quarter some number of quarters ago.
        # Returns nil if no single quarter can be identified.
        # @param offset [Integer] the number of quarters back to shift this period
        # @return [Calendar::Quarter, nil]

        # @!method quarters_ahead
        # Get the index-relative quarter some number of quarters ahead.
        # Returns nil if no single quarter can be identified.
        # @param offset [Integer] the number of quarters forward to shift this period
        # @return [Calendar::Quarter, nil]

        # @!method last_quarter
        # Get the index-relative quarter 1 quarter ago.
        # Returns nil if no single quarter can be identified.
        # @return [Calendar::Quarter, nil]

        # @!method this_quarter
        # Get the index-relative quarter for this quarter.
        # Returns nil if no single quarter can be identified.
        # @return [Calendar::Quarter, nil]

        # @!method next_quarter
        # Get the index-relative quarter 1 quarter forward.
        # Returns nil if no single quarter can be identified.
        # @return [Calendar::Quarter, nil]

        ### Halves

        # @!method in_half
        # Get the index within the half that this unit falls in.
        # Returns nil if no single half can be identified.
        # @return [Integer, nil]

        # @!method halves_ago
        # Get the index-relative half some number of halves ago.
        # Returns nil if no single half can be identified.
        # @param offset [Integer] the number of halves back to shift this period
        # @return [Calendar::Half, nil]

        # @!method halves_ahead
        # Get the index-relative half some number of halves ahead.
        # Returns nil if no single half can be identified.
        # @param offset [Integer] the number of halves forward to shift this period
        # @return [Calendar::Half, nil]

        # @!method last_half
        # Get the index-relative half 1 half ago.
        # Returns nil if no single half can be identified.
        # @return [Calendar::Half, nil]

        # @!method this_half
        # Get the index-relative half for this half.
        # Returns nil if no single half can be identified.
        # @return [Calendar::Half, nil]

        # @!method next_half
        # Get the index-relative half 1 half forward.
        # Returns nil if no single half can be identified.
        # @return [Calendar::Half, nil]

        ### Years

        # @!method in_year
        # Get the index within the year that this unit falls in.
        # Returns nil if no single year can be identified.
        # @return [Integer, nil]

        # @!method years_ago
        # Get the index-relative year some number of years ago.
        # Returns nil if no single year can be identified.
        # @param offset [Integer] the number of years back to shift this period
        # @return [Calendar::Year, nil]

        # @!method years_ahead
        # Get the index-relative year some number of years ahead.
        # Returns nil if no single year can be identified.
        # @param offset [Integer] the number of years forward to shift this period
        # @return [Calendar::Year, nil]

        # @!method last_year
        # Get the index-relative year 1 year ago.
        # Returns nil if no single year can be identified.
        # @return [Calendar::Year, nil]

        # @!method this_year
        # Get the index-relative year for this year.
        # Returns nil if no single year can be identified.
        # @return [Calendar::Year, nil]

        # @!method next_year
        # Get the index-relative year 1 year forward.
        # Returns nil if no single year can be identified.
        # @return [Calendar::Year, nil]
      end
    end
  end
end
