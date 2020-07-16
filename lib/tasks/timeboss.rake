namespace :timeboss do
  task :init do
    require './lib/timeboss'
    require './lib/timeboss/calendars'
  end
end
