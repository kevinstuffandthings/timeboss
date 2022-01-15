# frozen_string_literal: true

require "active_support/inflector"
require "active_support/core_ext/numeric/time"

%w[day week month quarter half year].each { |f| require_relative "./calendar/#{f}" }
%w[waypoints period parser].each { |f| require_relative "./calendar/#{f}" }
require_relative "./calendar/support/month_basis"

module TimeBoss
  class Calendar
    include Waypoints

    # @!method parse
    # Parse an identifier into a unit or period.
    #   Valid identifiers can include simple units (like "2020Q3", "2020M8W3", "last_quarter"),
    #   mathematical expressions (like "this_month+6"),
    #   or period expressions (like "2020W1..2020W8", "this_quarter-2..next_quarter")
    # @param identifier [String]
    # @return [Support::Unit, Period]

    delegate :parse, to: :parser

    # Get a name by which this calendar can be referenced.
    # @return [String]
    def name
      self.class.to_s.demodulize.underscore
    end
    alias_method :to_s, :name

    # Get a friendly title for this calendar.
    # @return [String]
    def title
      name.titleize
    end

    # Can this calendar support weeks?
    # To support weeks, a calendar must implement a `#weeks_in(year:)` method that returns an array of
    # `Calendar::Week` objects.
    # @return [Boolean]
    def supports_weeks?
      respond_to?(:weeks_in)
    end

    def self.register!
      return unless TimeBoss::Calendars.method_defined?(:register)
      TimeBoss::Calendars.register(name.to_s.demodulize.underscore, self)
    end
    private_class_method :register!

    protected

    attr_reader :basis

    def initialize(basis:)
      @basis = basis
    end

    def build_week(year, start_date)
      Week.new(self, start_date, start_date + 6.days)
    end

    private

    def parser
      @_parser ||= Parser.new(self)
    end
  end
end
