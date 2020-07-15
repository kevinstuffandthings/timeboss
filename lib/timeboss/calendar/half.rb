# frozen_string_literal: true
require_relative './support/month_based'

module TimeBoss
  class Calendar
    class Half < Support::MonthBased
      NUM_MONTHS = 6

      def name
        "#{year_index}H#{index}"
      end

      def title
        "H#{index} #{year_index}"
      end
    end
  end
end
