# frozen_string_literal: true
module TimeBoss
  class Calendar
    # The parser is responsible for the implementation of a calendar's identifier parsing abilities.
    class Parser
      RANGE_DELIMITER = '..'
      InvalidPeriodIdentifierError = Class.new(StandardError)
      attr_reader :calendar

      def initialize(calendar)
        @calendar = calendar
      end

      def parse(identifier = nil)
        return parse_identifier(identifier.presence) unless identifier&.include?(RANGE_DELIMITER)
        bases = identifier.split(RANGE_DELIMITER).map { |i| parse_identifier(i.strip) } unless identifier.nil?
        bases ||= [parse_identifier(nil)]
        Period.new(calendar, *bases)
      rescue ArgumentError
        raise InvalidPeriodIdentifierError
      end

      private

      def parse_identifier(identifier)
        captures = identifier&.match(/^([^-]+)(\s*[+-]\s*[0-9]+)$/)&.captures
        base, offset = captures || [identifier, '0']
        period = parse_period(base&.strip) or raise InvalidPeriodIdentifierError
        period.offset(offset.gsub(/\s+/, '').to_i)
      end

      def parse_period(identifier)
        return calendar.send(identifier) if calendar.respond_to?(identifier.to_s)
        parse_term(identifier || Date.today.year.to_s)
      end

      def parse_term(identifier)
        return Day.new(calendar, Date.parse(identifier)) if identifier.match?(/^[0-9]{4}-?[01][0-9]-?[0-3][0-9]$/)

        raise InvalidPeriodIdentifierError unless identifier.match?(/^[HQMWD0-9]+$/)
        period = if identifier.to_i == 0 then calendar.this_year else calendar.year(identifier.to_i) end
        %w[half quarter month week day].each do |size|
          prefix = size[0].upcase
          next unless identifier.include?(prefix)
          junk, identifier = identifier.split(prefix)
          raise InvalidPeriodIdentifierError if junk.match?(/\D/)
          period = period.send(size.pluralize)[identifier.to_i - 1] or raise InvalidPeriodIdentifierError
        end
        period
      end
    end
  end
end
