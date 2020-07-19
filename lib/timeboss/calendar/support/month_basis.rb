module TimeBoss
  class Calendar
    module Support
      # @abstract
      # Implementation of a month basis allows a custom calendar to be built.
      # A month basis must return a start/end date for a given year and month index.
      class MonthBasis
        attr_reader :year, :month

        def initialize(year, month)
          @year = year
          @month = month
        end

        def to_range
          @_to_range ||= start_date .. end_date
        end
      end
    end
  end
end
