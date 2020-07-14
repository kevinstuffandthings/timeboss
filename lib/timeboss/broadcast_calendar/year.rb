require_relative './support/month_based'

module TimeBoss
  module BroadcastCalendar
    class Year < Support::MonthBased
      NUM_MONTHS = 12

      def name
        year.to_s
      end

      def title
        name
      end
    end
  end
end
