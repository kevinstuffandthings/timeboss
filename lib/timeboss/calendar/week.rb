# frozen_string_literal: true
require_relative './support/unit'

module TimeBoss
  class Calendar
    class Week < Support::Unit
      def initialize(calendar, start_date, end_date)
        super(calendar, start_date, end_date)
      end

      def name
        "#{year_index}W#{index}"
      end

      def title
        "Week of #{start_date.strftime('%B %-d, %Y')}"
      end

      def to_s
        "#{name}: #{start_date} thru #{end_date}"
      end

      def index
        @_index ||= (((start_date - year.start_date) + 1) / 7.0).to_i + 1
      end

      def year_index
        @_year_index ||= year.year_index
      end

      private

      def down
        self.class.new(calendar, start_date - 1.week, end_date - 1.week)
      end

      def up
        self.class.new(calendar, start_date + 1.week, end_date + 1.week)
      end
    end
  end
end
