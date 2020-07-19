# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Support
      module Shiftable
        PERIODS = %w[day week month quarter half year]

        PERIODS.each do |period|
          periods = period.pluralize

          define_method(periods) { calendar.send("#{periods}_for", self) }

          define_method(period) do
            entries = send(periods)
            return nil unless entries.length == 1
            entries.first
          end

          define_method("in_#{period}") do
            base = send(periods)
            return unless base.length == 1
            base.first.send(self.class.type.to_s.pluralize).find_index { |p| p == self } + 1
          end

          define_method("#{periods}_ago") do |offset|
            base_offset = send("in_#{period}") or return
            (calendar.send("this_#{period}") - offset).send(self.class.type.to_s.pluralize)[base_offset - 1]
          end

          define_method("#{periods}_ahead") { |o| send("#{periods}_ago", o * -1) }

          define_method("last_#{period}") { send("#{periods}_ago", 1) }
          define_method("this_#{period}") { send("#{periods}_ago", 0) }
          define_method("next_#{period}") { send("#{periods}_ahead", 1) }
        end

        alias_method :yesterday, :last_day
        alias_method :today, :this_day
        alias_method :tomorrow, :next_day

        #
        # i hate this
        #

        ### Days

        # @!method days
        # Get a list of days that fall within this unit.
        # @return [Array<Calendar::Day>]

        # @!method day
        # Get the day this unit represents.
        # Returns nil if no single day can be identified.
        # @return [Array<Calendar::Day>, nil]

        # @!method in_day
        # Get the index within the day that this unit falls in.
        # Returns nil if no single day can be identified.
        # @return [Integer, nil]

        # @!method days_ago
        # Get the index-relative day some number of days ago.
        # Returns nil if no single day can be identified.
        # @param offset [Integer] the number of days back to shift this period
        # @return [Calendar::Day, nil]

        # @!method days_ahead
        # Get the index-relative day some number of days ahead.
        # Returns nil if no single day can be identified.
        # @param offset [Integer] the number of days forward to shift this period
        # @return [Calendar::Day, nil]

        # @!method last_day
        # Get the index-relative day 1 day ago.
        # Returns nil if no single day can be identified.
        # @return [Calendar::Day, nil]

        # @!method this_day
        # Get the index-relative day for this day.
        # Returns nil if no single day can be identified.
        # @return [Calendar::Day, nil]

        # @!method next_day
        # Get the index-relative day 1 day forward.
        # Returns nil if no single day can be identified.
        # @return [Calendar::Day, nil]
      end
    end
  end
end
