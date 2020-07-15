namespace :timeboss do
  namespace :broadcast_calendar do
    desc "Open a shell with the broadcast calendar"
    task shell: ['timeboss:init'] do
      require 'timeboss/calendars/broadcast'
      TimeBoss::Calendars::Broadcast.new.extend(TimeBoss::Shellable).open_shell
    end
  end
end
