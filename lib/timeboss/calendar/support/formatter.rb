# frozen_string_literal: true
require_relative './translatable'

module TimeBoss
  class Calendar
    module Support
      private

      # The formatter is responsible for the implementation of name formatting for a unit.
      class Formatter
        PERIODS = Translatable::PERIODS.reverse.map(&:to_sym).drop(1)
        attr_reader :unit, :periods

        def initialize(unit, periods)
          @unit = unit
          @periods = PERIODS & periods.map(&:to_sym).push(unit.class.type.to_sym)
          @periods -= [:week] unless unit.calendar.supports_weeks?
        end

        def to_s
          base, text = 'year', unit.year.name
          periods.each do |period|
            sub = unit.public_send(period) or break
            index = sub.public_send("in_#{base}")
            text += "#{period[0].upcase}#{index}"
            base = period
          end
          text
        end
      end
    end
  end
end
