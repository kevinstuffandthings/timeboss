# frozen_string_literal: true
module TimeBoss
  module BroadcastCalendar
    class Period
      private

      class Entry
        attr_reader :entry
        delegate :name, :title, :start_date, :end_date, :current?, :to_s, to: :entry

        def initialize(entry)
          @entry = entry
        end

        def to_h
          {
            name: name,
            title: title,
            start_date: start_date,
            end_date: end_date,
            is_current: current?
          }
        end
      end
    end
  end
end
