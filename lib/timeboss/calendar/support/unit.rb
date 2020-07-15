# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Support
      class Unit
        attr_reader :calendar, :start_date, :end_date

        def self.type
          self.name.demodulize.underscore
        end

        def initialize(calendar, start_date, end_date)
          @calendar = calendar
          @start_date = start_date
          @end_date = end_date
        end

        def ==(entry)
          self.class == entry.class && self.start_date == entry.start_date && self.end_date == entry.end_date
        end

        def thru(unit)
          Period.new(calendar, self, unit)
        end

        def current?
          Date.today.between?(start_date, end_date)
        end

        def offset(value)
          method = value.negative? ? :previous : :next
          base = self
          value.abs.times { base = base.send(method) }
          base
        end

        %w[day week month quarter half year].each do |period|
          periods = period.pluralize

          define_method periods do
            calendar.send("#{periods}_for", self)
          end

          define_method period do
            entries = send(periods)
            return nil unless entries.length == 1
            entries.first
          end

          define_method "in_#{period}" do
            base = send(periods)
            return unless base.length == 1
            base.first.send(self.class.type.to_s.pluralize).find_index { |p| p == self } + 1
          end

          define_method "#{periods}_ago" do |offset|
            base_offset = send("in_#{period}") or return
            (calendar.send("this_#{period}") - offset).send(self.class.type.to_s.pluralize)[base_offset - 1]
          end

          define_method "last_#{period}" do
            send("#{periods}_ago", 1)
          end

          define_method "this_#{period}" do
            send("#{periods}_ago", 0)
          end

          define_method "#{periods}_hence" do |offset|
            send("#{periods}_ago", offset * -1)
          end

          define_method "next_#{period}" do
            send("#{periods}_hence", 1)
          end
        end

        def +(value)
          offset(value)
        end

        def -(value)
          offset(-value)
        end

        def to_range
          @_to_range ||= start_date .. end_date
        end
      end
    end
  end
end
