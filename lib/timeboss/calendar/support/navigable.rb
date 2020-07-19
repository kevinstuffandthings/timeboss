# frozen_string_literal: true
module TimeBoss
  class Calendar
    module Support
      module Navigable
        def previous(quantity = nil)
          return down if quantity.nil?
          gather(:previous, quantity).reverse
        end

        def next(quantity = nil)
          return up if quantity.nil?
          gather(:next, quantity)
        end

        def ago(quantity)
          previous(quantity + 1).first
        end

        def ahead(quantity)
          self.next(quantity + 1).last
        end

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
