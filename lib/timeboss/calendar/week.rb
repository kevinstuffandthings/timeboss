# frozen_string_literal: true
require_relative './support/unit'

module TimeBoss
  class Calendar
    class Week < Support::Unit
      attr_reader :parent, :index, :start_date, :end_date

      def initialize(calendar, parent, index, start_date, end_date)
        super(calendar)
        @parent = parent
        @index = index
        @start_date = start_date
        @end_date = end_date
      end

      def name
        "#{parent.name}W#{index}"
      end

      def title
        "Week of #{start_date.strftime('%B %-d, %Y')}"
      end

      def to_s
        "#{name}: #{start_date} thru #{end_date}"
      end

      def previous
        weeks = parent.weeks
        if index == 1
          parent.previous.weeks.last
        else
          weeks[index - 2]
        end
      end

      def next
        weeks = parent.weeks
        if index == weeks.last.index
          parent.next.weeks.first
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
