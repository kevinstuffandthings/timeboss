# frozen_string_literal: true

%w[absolute relative].each { |f| require_relative "./waypoints/#{f}" }

module TimeBoss
  class Calendar
    module Waypoints
      include Absolute
      include Relative
    end
  end
end
