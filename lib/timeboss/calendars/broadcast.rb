# frozen_string_literal: true
require_relative '../calendar'

module TimeBoss
  module Calendars
    class Broadcast < Calendar
      def initialize
        super(basis: Broadcast::Basis)
      end

      private

      class Basis
        attr_reader :year, :month

        def initialize(year, month)
          @year = year
          @month = month
        end

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

        def to_range
          start_date .. end_date
        end
      end
    end
  end
end
