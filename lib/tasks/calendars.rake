require './lib/timeboss/calendars'

namespace :timeboss do
  namespace :calendars do
    TimeBoss::Calendars.each do |entry|
      namespace entry.name do
        desc "Evaluate an expression for the #{entry.name} calendar"
        task :evaluate, %i[expression] => ['timeboss:init'] do |_, args|
          puts entry.calendar.parse(args[:expression])
        end

        desc "Open a shell with the #{entry.name} calendar"
        task shell: ['timeboss:init'] do
          require 'timeboss/support/shellable'
          TimeBoss::Support::Shellable.open(entry.calendar)
        end
      end
    end
  end
end
