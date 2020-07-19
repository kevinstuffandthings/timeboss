# frozen_string_literal: true
require_relative './support/monthly_unit'

module TimeBoss
  class Calendar
    # Representation of a 12-month period within a calendar.
    class Year < Support::MonthlyUnit
      NUM_MONTHS = 12

      # Get a simple representation of this year.
      # @return [String] (e.g. "2020")
      def name
        year_index.to_s
      end

      alias_method :title, :name
    end
  end
end
