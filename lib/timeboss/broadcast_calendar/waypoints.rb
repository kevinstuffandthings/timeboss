require_relative './support/basis'

module TimeBoss
  module BroadcastCalendar
    module Waypoints
      extend self

      %i[month quarter year].each do |type|
        klass = TimeBoss::BroadcastCalendar.const_get(type.to_s.classify)
        size = klass.const_get("NUM_MONTHS")

        define_method("this_#{type}") { send("#{type}_for", Date.today) }
        define_method("last_#{type}") { send("this_#{type}").previous }
        define_method("next_#{type}") { send("this_#{type}").next }

        define_method type do |year, index = 1|
          month = (index * size) - size + 1
          months = (month .. month + size - 1).map { |i| Support::Basis.new(year, i).to_range }
          klass.new(year, index, months.first.begin, months.last.end)
        end

        define_method "#{type}_for" do |date|
          window = send(type, date.year, (date.month / size.to_f).ceil)
          return window if date.between?(window.start_date, window.end_date)
          return window.next if date > window.end_date
          return window.previous if date < window.start_date
        end

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

        define_method "this_#{type}_last_year" do
          window = send("this_#{type}")
          send(type, window.year - 1, window.index)
        end

        define_method "this_#{type}_next_year" do
          window = send("this_#{type}")
          send(type, window.year + 1, window.index)
        end
      end

      def this_week
        this_year.weeks.find(&:current?)
      end

      def last_week
        this_week.previous
      end

      def next_week
        this_week.next
      end
    end
  end
end
