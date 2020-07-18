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

      def week(year_index, index)
        year(year_index).weeks[index - 1]
      end

      def week_for(date)
        year_for(date).weeks.find { |w| w.to_range.include?(date) }
      end

      def day(year_index, index)
        year(year_index).days[index - 1]
      end

      def day_for(date)
        Day.new(self, date)
      end

      %i[day week month quarter half year].each do |type|
        define_method("this_#{type}") { send("#{type}_for", Date.today) }
        define_method("last_#{type}") { send("this_#{type}").previous }
        define_method("next_#{type}") { send("this_#{type}").next }

        types = type.to_s.pluralize
        define_method("#{types}_for") { |p| send("#{type}_for", p.start_date).until(p.end_date) }
        define_method("#{types}_back") { |q| send("this_#{type}").previous(q) }
        define_method("#{types}_ago") { |q| send("this_#{type}").ago(q) }
        define_method("#{types}") { |q| send("this_#{type}").next(q) }
        define_method("#{types}_hence") { |q| send("this_#{type}").hence(q) }
      end

      alias_method :yesterday, :last_day
      alias_method :today, :this_day
      alias_method :tomorrow, :next_day
    end
  end
end
