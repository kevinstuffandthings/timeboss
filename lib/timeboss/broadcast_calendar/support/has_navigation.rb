module TimeBoss
  module BroadcastCalendar
    module Support
      module HasNavigation
        def current?
          Date.today.between?(start_date, end_date)
        end

        def offset(value)
          method = value.negative? ? :previous : :next
          base = self
          value.abs.times { base = base.send(method) }
          base
        end

        def +(value)
          offset(value)
        end

        def -(value)
          offset(-value)
        end
      end
    end
  end
end
