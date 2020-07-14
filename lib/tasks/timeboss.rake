namespace :timeboss do
  task :init do
    require './lib/timeboss'

    module TimeBoss
      module Shellable
        def open_shell
          require 'irb'
          IRB.setup nil
          IRB.conf[:MAIN_CONTEXT] = IRB::Irb.new.context
          require 'irb/ext/multi-irb'
          IRB.irb nil, self
        end
      end
    end
  end
end
