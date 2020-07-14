# frozen_string_literal: true
require 'active_support/inflector'
require 'active_support/core_ext/numeric/time'

%w[day week month quarter year].each { |f| require_relative "./broadcast_calendar/#{f}" }
%w[waypoints period parser].each { |f| require_relative "./broadcast_calendar/#{f}" }

module TimeBoss
  module BroadcastCalendar
    extend self
    delegate :parse, to: Parser

    def method_missing(message, *args, &block)
      return Waypoints.send(message, *args, &block) if Waypoints.respond_to?(message)
      super
    end

    def respond_to_missing?(message, include_private = false)
      Waypoints.respond_to? message
    end
  end
end
