# frozen_string_literal: true
require_relative './support/month_based'

module TimeBoss
  class Calendar
    class Month < Support::MonthBased
      NUM_MONTHS = 1

      def name
        "#{year_index}M#{index}"
      end

      def title
        "#{Date::MONTHNAMES[index]} #{year_index}"
      end
    end
  end
end
