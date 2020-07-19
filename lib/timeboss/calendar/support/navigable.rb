# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Support
      module Navigable
        # @overload previous
        #   Fetch the previous unit relative to this unit.
        #   @return [Unit]
        # @overload previous(value)
        #   Fetch some previous number of units relative to this unit
        #   @param quantity [Integer]
        #   @return [Array<Unit>]
        def previous(quantity = nil)
          return down if quantity.nil?
          gather(:previous, quantity).reverse
        end

        # @overload next
        #   Fetch the next unit relative to this unit.
        #   @return [Unit]
        # @overload next(value)
        #   Fetch some next number of units relative to this unit
        #   @param quantity [Integer]
        #   @return [Array<Unit>]
        def next(quantity = nil)
          return up if quantity.nil?
          gather(:next, quantity)
        end

        # Fetch the unit some number of units prior to this unit.
        # @param quantity [Integer]
        # @return [Unit]
        def ago(quantity)
          previous(quantity + 1).first
        end

        # Fetch the unit some number of units after this unit.
        # @param quantity [Integer]
        # @return [Unit]
        def ahead(quantity)
          self.next(quantity + 1).last
        end

        # Fetch a list of units from this unit until some date.
        # @param end_date [Date]
        # @return [Array<Unit>]
        def until(end_date)
          entry = self
          [entry].tap do |entries|
            until entry.end_date >= end_date
              entry = entry.next
              entries << entry
            end
          end
        end

        private

        def gather(navigator, quantity)
          [].tap do |entries|
            entry = self
            while quantity > 0
              entries << entry
              entry = entry.send(navigator)
              quantity -= 1
            end
          end
        end
      end
    end
  end
end
