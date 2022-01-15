# frozen_string_literal: true

require_relative "./support/unit"

module TimeBoss
  class Calendar
    class Week < Support::Unit
      def initialize(calendar, start_date, end_date)
        raise UnsupportedUnitError unless calendar.supports_weeks?
        super(calendar, start_date, end_date)
      end

      # Get a simple representation of this week.
      # @return [String] (e.g. "2020W32")
      def name
        "#{year_index}W#{index}"
      end

      # Get a "pretty" representation of this week.
      # @return [String] (e.g. "Week of August 3, 2020")
      def title
        "Week of #{start_date.strftime("%B %-d, %Y")}"
      end

      # Get a stringified representation of this week.
      # @return [String] (e.g. "2020W32: 2020-08-03 thru 2020-08-09")
      def to_s
        "#{name}: #{start_date} thru #{end_date}"
      end

      # Get the index of this week within its containing year.
      # @return [Integer]
      def index
        @_index ||= year.weeks.find_index { |w| w.start_date == start_date } + 1
      end

      # Get the year number for this week.
      # @return [Integer] (e.g. 2020)
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
