require_relative './support/month_based'

module TimeBoss
  module BroadcastCalendar
    class Quarter < Support::MonthBased
      NUM_MONTHS = 3

      def name
        "#{year}Q#{index}"
      end

      def title
        "Q#{index} #{year}"
      end
    end
  end
end
