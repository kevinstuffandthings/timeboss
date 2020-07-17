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

    def name
      self.class.to_s.demodulize.underscore
    end

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
