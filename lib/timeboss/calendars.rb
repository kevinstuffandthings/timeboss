# frozen_string_literal: true
require 'active_support/core_ext/class/subclasses'
require './lib/timeboss/calendar'
Dir['./lib/timeboss/calendars/*.rb'].each { |f| require f }

module TimeBoss
  module Calendars
    extend self
    extend Enumerable
    delegate :each, :length, to: :all

    def all
      @_all ||= TimeBoss::Calendar.subclasses.map do |klass|
        Entry.new(klass.to_s.demodulize.underscore.to_sym, klass)
      end
    end

    def [](name)
      find { |e| e.name == name.to_sym }&.calendar
    end

    private

    Entry = Struct.new(:name, :klass) do
      def calendar
        @_calendar ||= klass.new
      end
    end
  end
end
