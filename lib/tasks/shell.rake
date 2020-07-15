namespace :timeboss do
  namespace :calendars do
    calendars = Dir['./lib/timeboss/calendars/*.rb'].map { |f| File.basename(f, '.rb').to_sym }
    calendars.each do |calendar|
      namespace calendar do
        desc "Open a shell with the #{calendar} calendar"
        task shell: ['timeboss:init'] do
          require "timeboss/calendars/#{calendar}"
          klass = TimeBoss::Calendars.const_get(calendar.to_s.classify)
          klass.new.extend(TimeBoss::Shellable).open_shell
        end
      end
    end
  end
end
