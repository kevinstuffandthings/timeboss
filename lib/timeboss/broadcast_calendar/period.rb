module TimeBoss
  module BroadcastCalendar
    class Period
      attr_reader :begin, :end

      %i[months quarters years].each do |size|
        define_method(size) do
          entry = BroadcastCalendar.send("#{size.to_s.singularize}_for", self.begin.start_date)
          build_entries entry
        end
      end

      def name
        name = self.begin.name
        name = "#{name} thru #{self.end.name}" unless self.end == self.begin
        name
      end

      def weeks
        year = BroadcastCalendar.send("year_for", self.begin.start_date)
        entry = year.weeks.find { |w| w.range.include?(self.begin.start_date) }
        build_entries entry
      end

      private

      def initialize(begin_basis, end_basis = nil)
        @begin = begin_bases
        @end = end_basis || @begin
      end

      def build_entries(entry)
        return [] if entry.start_date > self.end.end_date
        entries = [Entry.new(entry)]
        while entry.end_date < self.end.end_date
          entry = entry.next
          entries << Entry.new(entry)
        end
        entries
      end

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
