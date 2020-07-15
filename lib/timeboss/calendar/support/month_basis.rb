module TimeBoss
  class Calendar
    module Support
      class MonthBasis
        attr_reader :year, :month

        def initialize(year, month)
          @year = year
          @month = month
        end

        def to_range
          start_date .. end_date
        end
      end
    end
  end
end
