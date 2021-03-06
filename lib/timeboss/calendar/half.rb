# frozen_string_literal: true

require_relative "./support/monthly_unit"

module TimeBoss
  class Calendar
    class Half < Support::MonthlyUnit
      NUM_MONTHS = 6

      # Get a simple representation of this half.
      # @return [String] (e.g. "2020H2")
      def name
        "#{year_index}H#{index}"
      end

      # Get a "pretty" representation of this half.
      # @return [String] (e.g. "H2 2020")
      def title
        "H#{index} #{year_index}"
      end
    end
  end
end
