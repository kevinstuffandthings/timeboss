# frozen_string_literal: true
require_relative './support/unit'

module TimeBoss
  module BroadcastCalendar
    Day = Struct.new(:start_date) do
      include Support::Unit
      alias_method :end_date, :start_date

      def name
        start_date.to_s
      end

      def title
        start_date.strftime('%B %-d, %Y')
      end

      def to_s
        name
      end

      def index
        @_index ||= (start_date - TimeBoss::BroadcastCalendar.year_for(start_date).start_date).to_i + 1
      end

      def previous
        self.class.new(start_date - 1.day)
      end

      def next
        self.class.new(start_date + 1.day)
      end

      def range
        start_date..end_date
      end
    end
  end
end
