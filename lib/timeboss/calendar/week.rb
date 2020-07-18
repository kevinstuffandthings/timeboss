# frozen_string_literal: true
require_relative './support/unit'

module TimeBoss
  class Calendar
    class Week < Support::Unit
      attr_reader :year_index, :index

      def initialize(calendar, year_index, index, start_date, end_date)
        super(calendar, start_date, end_date)
        @year_index = year_index
        @index = index
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

      private

      def down
        if index == 1
          (calendar.year_for(start_date) - 1).weeks.last
        else
          self.class.new(calendar, year_index, index - 1, start_date - 1.week, end_date - 1.week)
        end
      end

      def up
        weeks = calendar.year_for(start_date).weeks
        if index == weeks.last.index
          self.class.new(calendar, year_index + 1, 1, start_date + 1.week, end_date + 1.week)
        else
          weeks[index]
        end
      end
    end
  end
end
