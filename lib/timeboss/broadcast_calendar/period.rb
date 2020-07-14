# frozen_string_literal: true
module TimeBoss
  module BroadcastCalendar
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

      %i[months quarters years].each do |size|
        define_method(size) do
          entry = BroadcastCalendar.send("#{size.to_s.singularize}_for", self.begin.start_date)
          build_entries entry
        end
      end

      def days
        (start_date .. end_date).map { |d| Day.new(d) }
      end

      def weeks
        year = BroadcastCalendar.send("year_for", self.begin.start_date)
        entry = year.weeks.find { |w| w.range.include?(self.begin.start_date) }
        build_entries entry
      end

      private

      def initialize(begin_basis, end_basis = nil)
        @begin = begin_basis
        @end = end_basis || @begin
      end

      def build_entries(entry)
        return [] if entry.start_date > self.end.end_date
        entries = [Entry.new(entry)]
        while entry.end_date < self.end.end_date
          entry = entry.next
          entries << Entry.new(entry)
        end
        entries
      end
    end
  end
end

require_relative './period/entry'
