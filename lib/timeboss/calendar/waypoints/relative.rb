# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Waypoints
      module Relative
        %i[day week month quarter half year].each do |type|
          types = type.to_s.pluralize

          define_method("this_#{type}") { public_send("#{type}_for", Date.today) }
          define_method("last_#{type}") { public_send("this_#{type}").previous }
          define_method("next_#{type}") { public_send("this_#{type}").next }

          define_method("#{types}_for") { |p| public_send("#{type}_for", p.start_date).until(p.end_date) }

          define_method("#{types}_back") { |q| public_send("this_#{type}").previous(q) }
          define_method("#{types}_ago") { |q| public_send("this_#{type}").ago(q) }

          define_method("#{types}_forward") { |q| public_send("this_#{type}").next(q) }
          define_method("#{types}_ahead") { |q| public_send("this_#{type}").ahead(q) }
          alias_method types.to_sym, "#{types}_forward".to_sym
        end

        alias_method :yesterday, :last_day
        alias_method :today, :this_day
        alias_method :tomorrow, :next_day

        #
        # i hate this
        #

        ### Days

        # @!method this_day
        # Get the current day within the active calendar.
        # @return [Calendar::Day]

        # @!method last_day
        # Get the previous day within the active calendar.
        # @return [Calendar::Day]

        # @!method next_day
        # Get the next day within the active calendar.
        # @return [Calendar::Day]

        # @!method days_for
        # Get a list of days within the specified period unit.
        # @param period [Calendar::Support::Unit] the containing period unit
        # @return [Array<Calendar::Day>]

        # @!method days_back
        # Get a quantity of days back from today.
        # @param quantity [Integer] the number of days requested
        # @return [Array<Calendar::Day>]

        # @!method days_ago
        # Get the day that occurred the specified number of days ago.
        # @param quantity [Integer] the number of days before today
        # @return [Calendar::Day]

        # @!method days_forward
        # Get a quantity of days forward from today.
        # @param quantity [Integer] the number of days requested
        # @return [Array<Calendar::Day>]

        # @!method days_ahead
        # Get the day that occurred the specified number of days ahead.
        # @param quantity [Integer] the number of days after today
        # @return [Calendar::Day]
 
        ### Weeks

        # @!method this_week
        # Get the current week within the active calendar.
        # @return [Calendar::Week]

        # @!method last_week
        # Get the previous week within the active calendar.
        # @return [Calendar::Week]

        # @!method next_week
        # Get the next week within the active calendar.
        # @return [Calendar::Week]

        # @!method weeks_for
        # Get a list of weeks within the specified period unit.
        # @param period [Calendar::Support::Unit] the containing period unit
        # @return [Array<Calendar::Week>]

        # @!method weeks_back
        # Get a quantity of weeks back from this week.
        # @param quantity [Integer] the number of weeks requested
        # @return [Array<Calendar::Week>]

        # @!method weeks_ago
        # Get the week that occurred the specified number of weeks ago.
        # @param quantity [Integer] the number of weeks before this week
        # @return [Calendar::Week]

        # @!method weeks_forward
        # Get a quantity of weeks forward from this week.
        # @param quantity [Integer] the number of weeks requested
        # @return [Array<Calendar::Week>]

        # @!method weeks_ahead
        # Get the week that occurred the specified number of weeks ahead.
        # @param quantity [Integer] the number of weeks after this week
        # @return [Calendar::Week]
 
        ### Months

        # @!method this_month
        # Get the current month within the active calendar.
        # @return [Calendar::Month]

        # @!method last_month
        # Get the previous month within the active calendar.
        # @return [Calendar::Month]

        # @!method next_month
        # Get the next month within the active calendar.
        # @return [Calendar::Month]

        # @!method months_for
        # Get a list of months within the specified period unit.
        # @param period [Calendar::Support::Unit] the containing period unit
        # @return [Array<Calendar::Month>]

        # @!method months_back
        # Get a quantity of months back from this month.
        # @param quantity [Integer] the number of months requested
        # @return [Array<Calendar::Month>]

        # @!method months_ago
        # Get the month that occurred the specified number of months ago.
        # @param quantity [Integer] the number of months before this month
        # @return [Calendar::Month]

        # @!method months_forward
        # Get a quantity of months forward from this month.
        # @param quantity [Integer] the number of months requested
        # @return [Array<Calendar::Month>]

        # @!method months_ahead
        # Get the month that occurred the specified number of months ahead.
        # @param quantity [Integer] the number of months after this month
        # @return [Calendar::Month]
 
        ### Quarters

        # @!method this_quarter
        # Get the current quarter within the active calendar.
        # @return [Calendar::Quarter]

        # @!method last_quarter
        # Get the previous quarter within the active calendar.
        # @return [Calendar::Quarter]

        # @!method next_quarter
        # Get the next quarter within the active calendar.
        # @return [Calendar::Quarter]

        # @!method quarters_for
        # Get a list of quarters within the specified period unit.
        # @param period [Calendar::Support::Unit] the containing period unit
        # @return [Array<Calendar::Quarter>]

        # @!method quarters_back
        # Get a quantity of quarters back from this quarter.
        # @param quantity [Integer] the number of quarters requested
        # @return [Array<Calendar::Quarter>]

        # @!method quarters_ago
        # Get the quarter that occurred the specified number of quarters ago.
        # @param quantity [Integer] the number of quarters before this quarter
        # @return [Calendar::Quarter]

        # @!method quarters_forward
        # Get a quantity of quarters forward from this quarter.
        # @param quantity [Integer] the number of quarters requested
        # @return [Array<Calendar::Quarter>]

        # @!method quarters_ahead
        # Get the quarter that occurred the specified number of days ahead.
        # @param quantity [Integer] the number of quarters after this quarter
        # @return [Calendar::Quarter]
 
        ### Halves

        # @!method this_half
        # Get the current half within the active calendar.
        # @return [Calendar::Half]

        # @!method last_half
        # Get the previous half within the active calendar.
        # @return [Calendar::Half]

        # @!method next_half
        # Get the next half within the active calendar.
        # @return [Calendar::Half]

        # @!method halves_for
        # Get a list of halves within the specified period unit.
        # @param period [Calendar::Support::Unit] the containing period unit
        # @return [Array<Calendar::Half>]

        # @!method halves_back
        # Get a quantity of halves back from this half.
        # @param quantity [Integer] the number of halves requested
        # @return [Array<Calendar::Half>]

        # @!method halves_ago
        # Get the half that occurred the specified number of halves ago.
        # @param quantity [Integer] the number of halves before this half
        # @return [Calendar::Half]

        # @!method halves_forward
        # Get a quantity of halves forward from this half.
        # @param quantity [Integer] the number of halves requested
        # @return [Array<Calendar::Half>]

        # @!method halves_ahead
        # Get the half that occurred the specified number of halves ahead.
        # @param quantity [Integer] the number of halves after this half
        # @return [Calendar::Half]
 
        ### Years

        # @!method this_year
        # Get the current year within the active calendar.
        # @return [Calendar::Year]

        # @!method last_year
        # Get the previous year within the active calendar.
        # @return [Calendar::Year]

        # @!method next_year
        # Get the next year within the active calendar.
        # @return [Calendar::Year]

        # @!method years_for
        # Get a list of years within the specified period unit.
        # @param period [Calendar::Support::Unit] the containing period unit
        # @return [Array<Calendar::Year>]

        # @!method years_back
        # Get a quantity of years back from this year.
        # @param quantity [Integer] the number of years requested
        # @return [Array<Calendar::Year>]

        # @!method years_ago
        # Get the year that occurred the specified number of years ago.
        # @param quantity [Integer] the number of years before this year
        # @return [Calendar::Year]

        # @!method years_forward
        # Get a quantity of years forward from this year.
        # @param quantity [Integer] the number of years requested
        # @return [Array<Calendar::Year>]

        # @!method years_ahead
        # Get the year that occurred the specified number of years ahead.
        # @param quantity [Integer] the number of years after this year
        # @return [Calendar::Year]
      end
    end
  end
end
