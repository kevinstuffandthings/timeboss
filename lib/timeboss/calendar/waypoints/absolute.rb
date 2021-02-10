# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Waypoints
      module Absolute
        %i[month quarter half year].each do |type|
          klass = TimeBoss::Calendar.const_get(type.to_s.classify)
          size = klass.const_get("NUM_MONTHS")

          define_method type do |year_index, index = 1|
            month = (index * size) - size + 1
            months = (month .. month + size - 1).map { |i| basis.new(year_index, i) }
            klass.new(self, year_index, index, months.first.start_date, months.last.end_date)
          end

          define_method "#{type}_for" do |date|
            window = public_send(type, date.year - 1, 1)
            while true
              break window if window.to_range.include?(date)
              window = window.next
            end
          end
        end

        # Get the specified week by index within the specified year.
        # @param year_index [Integer] the year to examine
        # @param index [Integer] the index of the week within the year
        # @return [Calendar::Week]
        def week(year_index, index)
          year(year_index).weeks[index - 1]
        end

        # Get the week that contains the specified date.
        # @param date [Date] the date for which to locate the calendar week
        # @return [Calendar::Week]
        def week_for(date)
          year_for(date).weeks.find { |w| w.to_range.include?(date) }
        end

        # Get the specified day by index within the specified year.
        # @param year_index [Integer] the year to examine
        # @param index [Integer] the index of the day within the year
        # @return [Calendar::Day]
        def day(year_index, index)
          year(year_index).days[index - 1]
        end

        # Get the day that contains the specified date.
        # @param date [Date] the date for which to locate the calendar day
        # @return [Calendar::Day]
        def day_for(date)
          Day.new(self, date)
        end

        #
        # i hate this
        #

        ### Month

        # @!method month
        # Get the specified month by index within the specified year
        # @param year_index [Integer] the year to examine
        # @param index [Integer] the index of the month within the year
        # @return [Calendar::Month]

        # @!method month_for
        # Get the month that contains the specified date.
        # @param date [Date] the date for which to locate the calendar month
        # @return [Calendar::Month]

        ### Quarter

        # @!method quarter
        # Get the specified quarter by index within the specified year
        # @param year_index [Integer] the year to examine
        # @param index [Integer] the index of the quarter within the year
        # @return [Calendar::Quarter]

        # @!method quarter_for
        # Get the quarter that contains the specified date.
        # @param date [Date] the date for which to locate the calendar quarter
        # @return [Calendar::Quarter]

        ### Half

        # @!method half
        # Get the specified half by index within the specified year
        # @param year_index [Integer] the year to examine
        # @param index [Integer] the index of the half within the year
        # @return [Calendar::Half]

        # @!method half_for
        # Get the half that contains the specified date.
        # @param date [Date] the date for which to locate the calendar half
        # @return [Calendar::Half]

        ### Year

        # @!method year
        # Get the specified year by index within the specified year
        # @param year_index [Integer] the year to examine
        # @param index [Integer] the index of the year within the year
        # @return [Calendar::Year]

        # @!method year_for
        # Get the year that contains the specified date.
        # @param date [Date] the date for which to locate the calendar year
        # @return [Calendar::Year]
      end
    end
  end
end
