require "./lib/timeboss"
require "./lib/timeboss/calendars"

namespace :timeboss do
  namespace :calendars do
    TimeBoss::Calendars.each do |entry|
      namespace entry.name do
        desc "Evaluate an expression for the #{entry.name} calendar"
        task :evaluate, %i[expression] => ["timeboss:init"] do |_, args|
          puts entry.calendar.parse(args[:expression])
        end

        desc "Open a REPL with the #{entry.name} calendar"
        task repl: ["timeboss:init"] do
          require "shellable"
          Shellable.open(entry.calendar)
        end

        task shell: ["timeboss:calendars:#{entry.name}:repl"]
      end
    end
  end
end
