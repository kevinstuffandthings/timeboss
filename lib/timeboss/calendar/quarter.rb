# frozen_string_literal: true
require_relative './support/month_based'

module TimeBoss
  class Calendar
    # Representation of a 3-month period within a calendar.
    class Quarter < Support::MonthBased
      NUM_MONTHS = 3

      # Get a simple representation of this quarter.
      # @return [String] (e.g. "2020Q3")
      def name
        "#{year_index}Q#{index}"
      end

      # Get a "pretty" representation of this quarter.
      # @return [String] (e.g. "Q3 2020")
      def title
        "Q#{index} #{year_index}"
      end
    end
  end
end
