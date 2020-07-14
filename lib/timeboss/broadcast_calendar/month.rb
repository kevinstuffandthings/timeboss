require_relative './support/month_based'

module TimeBoss
  module BroadcastCalendar
    class Month < Support::MonthBased
      NUM_MONTHS = 1

      def name
        "#{year}M#{index}"
      end

      def title
        "#{Date::MONTHNAMES[index]} #{year}"
      end
    end
  end
end
