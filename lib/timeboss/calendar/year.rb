# frozen_string_literal: true
require_relative './support/month_based'

module TimeBoss
  class Calendar
    class Year < Support::MonthBased
      NUM_MONTHS = 12

      def name
        year_index.to_s
      end

      def title
        name
      end
    end
  end
end
