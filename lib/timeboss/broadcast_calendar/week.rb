# frozen_string_literal: true
require_relative './support/unit'

module TimeBoss
  module BroadcastCalendar
    Week = Struct.new(:parent, :index, :start_date, :end_date) do
      include Support::Unit

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
