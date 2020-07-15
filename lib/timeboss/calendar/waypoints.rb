# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Waypoints
      %i[month quarter half year].each do |type|
        klass = TimeBoss::Calendar.const_get(type.to_s.classify)
        size = klass.const_get("NUM_MONTHS")

        define_method type do |year_index, index = 1|
          month = (index * size) - size + 1
          months = (month .. month + size - 1).map { |i| basis.new(year_index, i) }
          klass.new(self, year_index, index, months.first.start_date, months.last.end_date)
        end

        define_method "#{type}_for" do |date|
          window = send(type, date.year - 1, 1)
          while true
            break window if window.to_range.include?(date)
            window = window.next
          end
        end
      end

      %i[day week month quarter half year].each do |type|
        define_method("this_#{type}") { send("#{type}_for", Date.today) }
        define_method("last_#{type}") { send("this_#{type}").previous }
        define_method("next_#{type}") { send("this_#{type}").next }

        define_method "#{type.to_s.pluralize}_for" do |entry|
          first = send("#{type}_for", entry.start_date)
          constituents = [first]
          until first.end_date >= entry.end_date
            first = first.next
            constituents << first
          end
          constituents
        end

        define_method "#{type.to_s.pluralize}_back" do |quantity|
          windows = []
          window = send("this_#{type}")
          while quantity > 0
            windows << window.dup
            window = window.previous
            quantity -= 1
          end
          windows.reverse
        end

        define_method "#{type.to_s.pluralize}_ago" do |quantity|
          send("#{type.to_s.pluralize}_back", quantity + 1).first
        end

        define_method type.to_s.pluralize do |quantity|
          windows = []
          window = send("this_#{type}")
          while quantity > 0
            windows << window.dup
            window = window.next
            quantity -= 1
          end
          windows
        end

        define_method "#{type.to_s.pluralize}_hence" do |quantity|
          send(type.to_s.pluralize, quantity + 1).last
        end
      end

      %i[yesterday today tomorrow].each do |period|
        define_method(period) { Day.new(self, Date.send(period)) }
      end

      def day(year_index, index)
        year(year_index).days[index - 1]
      end

      def day_for(date)
        Day.new(self, date)
      end

      def week_for(date)
        year_for(date).weeks.find { |w| w.to_range.include?(date) }
      end
    end
  end
end
