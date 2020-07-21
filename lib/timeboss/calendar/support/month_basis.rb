module TimeBoss
  class Calendar
    module Support
      # @abstract
      # A MonthBasis must define a `#start_date` and `#end_date` method.
      # These methods should be calculated based on the incoming `#year` and `#month` values.
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
