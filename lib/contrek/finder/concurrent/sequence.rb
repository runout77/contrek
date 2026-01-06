module Contrek
  module Concurrent
    class Sequence
      prepend Queueable

      def is_not_vertical
        return false if size < 2
        x0 = head.payload[:x]
        rewind!
        while (position = iterator)
          return true if position.payload[:x] != x0
          forward!
        end
        false
      end
    end
  end
end
