module TimeBoss
  module BroadcastCalendar
    module Parsers
      class Term
        def self.parse(text)
          return nil if text.blank?
          if text.include?('W')
            parent = parse(text.split('W').first)
            return parent.weeks[text.split('W').last.to_i - 1]
          end
          return BroadcastCalendar.month(*text.split('M').map(&:to_i)) if text.include?('M')
          return BroadcastCalendar.quarter(*text.split('Q').map(&:to_i)) if text.include?('Q')
          return BroadcastCalendar.year(text.to_i) if text.match(/^20[0-9][0-9]$/)
          Day.new(Date.parse(text))
        end
      end
    end
  end
end
