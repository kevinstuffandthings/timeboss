# frozen_string_literal: true
require_relative './support/month_based'

module TimeBoss
  class Calendar
    class Half < Support::MonthBased
      NUM_MONTHS = 6

      def name
        "#{year}H#{index}"
      end

      def title
        "H#{index} #{year}"
      end
    end
  end
end
