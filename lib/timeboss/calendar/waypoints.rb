# frozen_string_literal: true

%w[absolute relative].each { |f| require_relative "./waypoints/#{f}" }

module TimeBoss
  class Calendar
    # Provides implementations for known periods within a calendar.
    module Waypoints
      include Absolute
      include Relative
    end
  end
end
