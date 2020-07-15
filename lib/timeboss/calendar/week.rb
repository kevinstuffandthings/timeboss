# frozen_string_literal: true
require_relative './support/unit'

module TimeBoss
  class Calendar
    class Week < Support::Unit
      attr_reader :year, :index, :start_date, :end_date

      def initialize(calendar, year, index, start_date, end_date)
        super(calendar)
        @year = year
        @index = index
        @start_date = start_date
        @end_date = end_date
      end

      def name
        "#{year}W#{index}"
      end

      def title
        "Week of #{start_date.strftime('%B %-d, %Y')}"
      end

      def to_s
        "#{name}: #{start_date} thru #{end_date}"
      end

      def previous
        if index == 1
          (calendar.year_for(start_date) - 1).weeks.last
        else
          self.class.new(calendar, year, index - 1, start_date - 1.week, end_date - 1.week)
        end
      end

      def next
        weeks = calendar.year_for(start_date).weeks
        if index == weeks.last.index
          self.class.new(calendar, year + 1, 1, start_date + 1.week, end_date + 1.week)
        else
          weeks[index]
        end
      end

      def range
        start_date..end_date
      end
    end
  end
end
