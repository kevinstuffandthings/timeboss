# frozen_string_literal: true
require 'active_support/inflector'
require 'active_support/core_ext/numeric/time'

%w[day week month quarter half year].each { |f| require_relative "./calendar/#{f}" }
%w[waypoints period parser].each { |f| require_relative "./calendar/#{f}" }
require_relative './calendar/support/month_basis'

module TimeBoss
  class Calendar
    include Waypoints
    delegate :parse, to: :parser

    # Get a name by which this calendar can be referenced.
    # @return [String]
    def name
      self.class.to_s.demodulize.underscore
    end

    # Get a friendly title for this calendar.
    # @return [String]
    def title
      name.titleize
    end

    protected

    attr_reader :basis

    def initialize(basis:)
      @basis = basis
    end

    private

    def parser
      @_parser ||= Parser.new(self)
    end
  end
end
