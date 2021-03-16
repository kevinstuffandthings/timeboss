# frozen_string_literal: true

require_relative "./support/unit"

module TimeBoss
  class Calendar
    class Day < Support::Unit
      def initialize(calendar, start_date)
        super(calendar, start_date, start_date)
      end

      # Get a simple representation of this day.
      # @return [String] (e.g. "2020-08-03")
      def name
        start_date.to_s
      end

      # Get a "pretty" representation of this day.
      # @return [String] (e.g. "August 3, 2020")
      def title
        start_date.strftime("%B %-d, %Y")
      end

      alias_method :to_s, :name

      # Get the index of this day within its containing year.
      # @return [Integer]
      def index
        @_index ||= (start_date - year.start_date).to_i + 1
      end

      # Get the year number for this day.
      # @return [Integer] (e.g. 2020)
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
