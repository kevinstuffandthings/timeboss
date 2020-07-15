# frozen_string_literal: true
module TimeBoss
  class Calendar
    class Period
      attr_reader :begin, :end
      delegate :start_date, to: :begin
      delegate :end_date, to: :end

      %i[name title to_s].each do |message|
        define_method(message) do
          text = self.begin.send(message)
          text = "#{text} #{Parser::RANGE_DELIMITER} #{self.end.send(message)}" unless self.end == self.begin
          text
        end
      end

      %w[week month quarter half year].each do |size|
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

      def current?
        (start_date .. end_date).include?(Date.today)
      end

      def days
        (start_date .. end_date).map { |d| Day.new(calendar, d) }
      end

      def day
        entries = days
        return nil unless entries.length == 1
        entries.first
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
