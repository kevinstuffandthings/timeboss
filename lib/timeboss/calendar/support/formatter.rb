# frozen_string_literal: true
require_relative './shiftable'

module TimeBoss
  class Calendar
    # @private
    module Support
      private

      # @private
      class Formatter
        PERIODS = Shiftable::PERIODS.reverse.map(&:to_sym).drop(1)
        attr_reader :unit, :periods

        def initialize(unit, periods)
          @unit = unit
          @periods = PERIODS & periods.map(&:to_sym).push(unit.class.type.to_sym)
        end

        def to_s
          base, text = 'year', unit.year.name
          periods.each do |period|
            sub = unit.send(period) or break
            index = sub.send("in_#{base}")
            text += "#{period[0].upcase}#{index}"
            base = period
          end
          text
        end
      end
    end
  end
end
