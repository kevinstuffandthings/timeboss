# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Support
      # Provides the ability to take a unit, and shift it into a different period, relative to today.
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

          define_method("last_#{period}") { send("#{periods}_ago", 1) }
          define_method("this_#{period}") { send("#{periods}_ago", 0) }
          define_method("#{periods}_ahead") { |o| send("#{periods}_ago", o * -1) }
          define_method("next_#{period}") { send("#{periods}_ahead", 1) }
        end
      end
    end
  end
end
