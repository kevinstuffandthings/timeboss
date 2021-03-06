# frozen_string_literal: true

module TimeBoss
  class Calendar
    class Parser
      RANGE_DELIMITER = ".."
      InvalidPeriodIdentifierError = Class.new(StandardError)
      attr_reader :calendar

      def initialize(calendar)
        @calendar = calendar
      end

      def parse(identifier = nil)
        return nil unless (identifier || "").strip.length > 0
        return parse_identifier(identifier) unless identifier&.include?(RANGE_DELIMITER)
        bases = identifier.split(RANGE_DELIMITER).map { |i| parse_identifier(i.strip) } unless identifier.nil?
        bases ||= [parse_identifier(nil)]
        Period.new(calendar, *bases)
      rescue ArgumentError
        raise InvalidPeriodIdentifierError
      end

      private

      def parse_identifier(identifier)
        captures = identifier&.match(/^([^-]+)(\s*[+-]\s*[0-9]+)$/)&.captures
        base, offset = captures || [identifier, "0"]
        (period = parse_period(base&.strip)) || raise(InvalidPeriodIdentifierError)
        period.offset(offset.gsub(/\s+/, "").to_i)
      end

      def parse_period(identifier)
        return calendar.public_send(identifier) if calendar.respond_to?(identifier.to_s)
        parse_term(identifier || Date.today.year.to_s)
      end

      def parse_term(identifier)
        return Day.new(calendar, Date.parse(identifier)) if identifier.match?(/^[0-9]{4}-?[01][0-9]-?[0-3][0-9]$/)

        raise InvalidPeriodIdentifierError unless identifier.match?(/^[HQMWD0-9]+$/)
        period = identifier.to_i == 0 ? calendar.this_year : calendar.year(identifier.to_i)
        %w[half quarter month week day].each do |size|
          prefix = size[0].upcase
          next unless identifier.include?(prefix)
          junk, identifier = identifier.split(prefix)
          raise InvalidPeriodIdentifierError if junk.match?(/\D/)
          (period = period.public_send(size.pluralize)[identifier.to_i - 1]) || raise(InvalidPeriodIdentifierError)
        end
        period
      end
    end
  end
end
