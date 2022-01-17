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
          text = self.begin.public_send(message)
          text = "#{text} #{Parser::RANGE_DELIMITER} #{self.end.public_send(message)}" unless self.end == self.begin
          text
        end
      end

      #
      # i hate this
      #

      ### Days

      # @!method days
      # Get a list of days that fall within this period.
      # @return [Array<Calendar::Day>]

      # @!method day(index = nil)
      # Get the day this period represents.
      # Returns nil if no single day can be identified.
      # @return [Array<Calendar::Day>, nil]

      ### Weeks

      # @!method weeks
      # Get a list of weeks that fall within this period.
      # @return [Array<Calendar::Week>]

      # @!method week(index = nil)
      # Get the week this period represents.
      # Returns nil if no single week can be identified.
      # @return [Array<Calendar::Week>, nil]

      ### Months

      # @!method months
      # Get a list of months that fall within this period.
      # @return [Array<Calendar::Month>]

      # @!method month(index = nil)
      # Get the month this period represents.
      # Returns nil if no single month can be identified.
      # @return [Array<Calendar::Month>, nil]

      ### Quarters

      # @!method quarters
      # Get a list of quarters that fall within this period.
      # @return [Array<Calendar::Quarter>]

      # @!method quarter(index = nil)
      # Get the quarter this period represents.
      # Returns nil if no single quarter can be identified.
      # @return [Array<Calendar::Quarter>, nil]

      ### Halves

      # @!method halves
      # Get a list of halves that fall within this period.
      # @return [Array<Calendar::Half>]

      # @!method half(index = nil)
      # Get the half this period represents.
      # Returns nil if no single half can be identified.
      # @return [Array<Calendar::Half>, nil]

      ### Years

      # @!method years
      # Get a list of years that fall within this period.
      # @return [Array<Calendar::Year>]

      # @!method year(index = nil)
      # Get the year this period represents.
      # Returns nil if no single year can be identified.
      # @return [Array<Calendar::Year>, nil]

      # Does this period cover the current date?
      # @return [Boolean]
      def current?
        to_range.include?(Date.today)
      end

      %w[day week month quarter half year].each do |size|
        define_method(size.pluralize) do
          entry = calendar.public_send("#{size}_for", self.begin.start_date) || self.begin.public_send(size, 1)
          build_entries entry
        end

        define_method(size) do |index = nil|
          entries = public_send(size.pluralize)
          return entries[index - 1] unless index.nil?
          return nil unless entries.length == 1
          entries.first
        end
      end

      # Express this period as a date range.
      # @return [Range<Date, Date>]
      def to_range
        @_to_range ||= start_date..end_date
      end

      def inspect
        "#<#{self.class.name}[#{self.begin.inspect}..#{self.end.inspect}] start_date=#{start_date}, end_date=#{end_date}>"
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
