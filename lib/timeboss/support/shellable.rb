module TimeBoss
  module Support
    module Shellable
      def self.open(context)
        context.extend(self).open_shell
      end

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
