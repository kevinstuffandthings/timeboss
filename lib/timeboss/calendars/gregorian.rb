# frozen_string_literal: true

require_relative "../calendar"
require_relative "../calendar/support/has_iso_weeks"

module TimeBoss
  module Calendars
    class Gregorian < Calendar
      include Support::HasIsoWeeks
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
