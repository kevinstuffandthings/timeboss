# frozen_string_literal: true
require_relative '../calendar'

module TimeBoss
  module Calendars
    class Broadcast < Calendar
      def initialize
        super(basis: Basis)
      end

      private

      class Basis < Calendar::Support::MonthBasis
        def start_date
          @_start_date ||= begin
                             date = Date.civil(year, month, 1)
                             date - (date.wday + 6) % 7
                           end
        end

        def end_date
          @_end_date ||= begin
                           date = Date.civil(year, month, -1)
                           date - date.wday
                         end
        end
      end
    end
  end
end
