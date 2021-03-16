# frozen_string_literal: true

require_relative "calendar"

module TimeBoss
  module Calendars
    extend self
    extend Enumerable
    delegate :each, :length, to: :all

    # Register a new calendar
    # @return [Entry]
    def register(name, klass)
      Entry.new(name.to_sym, klass).tap do |entry|
        (@entries ||= {})[name.to_sym] = entry
      end
    end

    # Retrieve a list of all registered calendars.
    # @return [Array<Entry>]
    def all
      return if @entries.nil?
      @entries.values.sort_by { |e| e.name.to_s }
    end

    # Retrieve an instance of the specified named calendar.
    # @param name [String, Symbol] the name of the calendar to retrieve.
    # @return [Calendar]
    def [](name)
      return if @entries.nil?
      @entries[name&.to_sym]&.calendar
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

Dir[File.expand_path("../calendars/*.rb", __FILE__)].each { |f| require f }
