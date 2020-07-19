# frozen_string_literal: true
module TimeBoss
  class Calendar
    class Period
      attr_reader :begin, :end

      # @!method start_date
      # Get the start date of this period.
      # @return [Date]
      delegate :start_date, to: :begin

      # @!method end_date
      # Get the end date of this period.
      # @return [Date]
      delegate :end_date, to: :end

      # @!method name
      # Get a simple representation of this period.
      # @return [String]

      # @!method title
      # Get a "pretty" representation of this period.
      # @return [String]

      # @!method to_s
      # Get a stringified representation of this period.
      # @return [String]

      %i[name title to_s].each do |message|
        define_method(message) do
          text = self.begin.send(message)
          text = "#{text} #{Parser::RANGE_DELIMITER} #{self.end.send(message)}" unless self.end == self.begin
          text
        end
      end

      %w[day week month quarter half year].each do |size|
        define_method(size.pluralize) do
          entry = calendar.send("#{size}_for", self.begin.start_date)
          build_entries entry
        end

        define_method(size) do
          entries = send(size.pluralize)
          return nil unless entries.length == 1
          entries.first
        end
      end

      # Does this period cover the current date?
      # @return [Boolean]
      def current?
        to_range.include?(Date.today)
      end

      # Express this period as a date range.
      # @return [Range<Date, Date>]
      def to_range
        @_to_range ||= start_date .. end_date
      end

      private

      attr_reader :calendar

      def initialize(calendar, begin_basis, end_basis = nil)
        @calendar = calendar
        @begin = begin_basis
        @end = end_basis || @begin
      end

      def build_entries(entry)
        return [] if entry.start_date > self.end.end_date
        entries = [entry]
        while entry.end_date < self.end.end_date
          entry = entry.next
          entries << entry
        end
        entries
      end
    end
  end
end
