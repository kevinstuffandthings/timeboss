module TimeBoss
  module BroadcastCalendar
    class Parser
      RANGE_DELIMITER = '..'
      InvalidPeriodIdentifierError = Class.new(StandardError)

      class << self
        def parse(identifier = nil)
          return parse_identifier(identifier.presence) unless identifier&.include?(RANGE_DELIMITER)
          bases = identifier.split(RANGE_DELIMITER).map { |i| parse_identifier(i) } unless identifier.nil?
          bases ||= [parse_identifier(nil)]
          Period.new(*bases)
        rescue ArgumentError
          raise InvalidPeriodIdentifierError
        end

        private

        def parse_identifier(identifier)
          captures = identifier&.match(/^([^-]+)([+-][1-9]+)$/)&.captures
          base, offset = captures || [identifier, 0]
          period = parse_period(base) or raise InvalidPeriodIdentifierError
          period.offset(offset.to_i)
        end

        def parse_period(identifier)
          return BroadcastCalendar.send(identifier) if BroadcastCalendar.respond_to?(identifier.to_s)
          return parse_term(Date.today.to_s) if %w[today now].include?(identifier.to_s)
          parse_term(identifier || Date.today.year.to_s)
        end

        def parse_term(identifier)
          return nil if identifier.blank?
          if identifier.include?('W')
            parent = parse(identifier.split('W').first)
            return parent.weeks[identifier.split('W').last.to_i - 1]
          end
          return BroadcastCalendar.month(*identifier.split('M').map(&:to_i)) if identifier.include?('M')
          return BroadcastCalendar.quarter(*identifier.split('Q').map(&:to_i)) if identifier.include?('Q')
          return BroadcastCalendar.year(identifier.to_i) if identifier.match(/^20[0-9][0-9]$/)
          suppress(ArgumentError) { Day.new(Date.parse(identifier)) }
        end
      end
    end
  end
end
