# frozen_string_literal: true

require_relative "../calendar"

module TimeBoss
  module Calendars
    class Broadcast < Calendar
      register!

      def initialize
        super(basis: Basis)
      end

      def weeks_in(year:)
        num_weeks = (((year.end_date - year.start_date) + 1) / 7.0).to_i
        num_weeks.times.map do |i|
          start_date = year.start_date + (i * 7).days
          Week.new(self, start_date, start_date + 6.days)
        end
      end

      private

      class Basis < Calendar::Support::MonthBasis
        def start_date
          @_start_date ||= begin
            date = Date.civil(year, month, 1)
            date - (date.wday + 6) % 7
          end
        end

        def end_date
          @_end_date ||= begin
            date = Date.civil(year, month, -1)
            date - date.wday
          end
        end
      end
    end
  end
end
