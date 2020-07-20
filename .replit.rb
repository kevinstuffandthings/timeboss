require 'bundler/inline'

gemfile true do
  source 'http://rubygems.org'
  gem 'timeboss'
end

require 'timeboss/calendars'
require 'timeboss/support/shellable'

calendar = TimeBoss::Calendars[:broadcast]
TimeBoss::Support::Shellable.open(calendar)
