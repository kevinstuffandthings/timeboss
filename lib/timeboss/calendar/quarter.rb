# frozen_string_literal: true
require_relative './support/month_based'

module TimeBoss
  class Calendar
    class Quarter < Support::MonthBased
      NUM_MONTHS = 3

      def name
        "#{year_index}Q#{index}"
      end

      def title
        "Q#{index} #{year_index}"
      end
    end
  end
end
