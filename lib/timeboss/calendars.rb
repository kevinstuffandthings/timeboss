# frozen_string_literal: true
require 'active_support/core_ext/class/subclasses'
require_relative 'calendar'

Dir[File.expand_path('../calendars/*.rb', __FILE__)].each { |f| require f }

module TimeBoss
  # A home for specific calendar implementations.
  module Calendars
    extend self
    extend Enumerable
    delegate :each, :length, to: :all

    # Retrieve a list of all registered calendars.
    # @return [Array<Entry>]
    def all
      @_all ||= TimeBoss::Calendar.subclasses.map do |klass|
        Entry.new(klass.to_s.demodulize.underscore.to_sym, klass)
      end
    end

    # Retrieve an instance of the specified named calendar.
    # @param name [String, Symbol] the name of the calendar to retrieve.
    # @return [Calendar]
    def [](name)
      find { |e| e.name == name&.to_sym }&.calendar
    end

    private

    Entry = Struct.new(:name, :klass) do
      # @!method name
      # Get the name of the calendar referenced in this entry.
      # @return [Symbol]

      # @!method klass
      # The class implementing this calendar.
      # @return [Class<Calendar>]

      # Get an instance of the calendar referenced in this entry.
      # @return [Calendar]
      def calendar
        @_calendar ||= klass.new
      end
    end
  end
end
