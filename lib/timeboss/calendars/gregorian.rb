# frozen_string_literal: true

require_relative "../calendar"

module TimeBoss
  module Calendars
    class Gregorian < Calendar
      register!

      def initialize
        super(basis: Basis)
      end

      private

      class Basis < Calendar::Support::MonthBasis
        def start_date
          @_start_date ||= Date.civil(year, month, 1)
        end

        def end_date
          @_end_date ||= Date.civil(year, month, -1)
        end
      end
    end
  end
end
