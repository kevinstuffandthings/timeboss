# frozen_string_literal: true
require_relative './support/monthly_unit'

module TimeBoss
  class Calendar
    # Representation of a single month within a calendar.
    class Month < Support::MonthlyUnit
      NUM_MONTHS = 1

      # Get a simple representation of this month.
      # @return [String] (e.g. "2020M8")
      def name
        "#{year_index}M#{index}"
      end

      # Get a "pretty" representation of this month.
      # @return [String] (e.g. "August 2020")
      def title
        "#{Date::MONTHNAMES[index]} #{year_index}"
      end
    end
  end
end
