# frozen_string_literal: true
require_relative './support/unit'

module TimeBoss
  class Calendar
    class Day < Support::Unit
      def initialize(calendar, start_date)
        super(calendar, start_date, start_date)
      end

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
        @_index ||= (start_date - year.start_date).to_i + 1
      end

      def year_index
        @_year_index ||= year.year_index
      end

      private

      def down
        self.class.new(calendar, start_date - 1.day)
      end

      def up
        self.class.new(calendar, start_date + 1.day)
      end
    end
  end
end
