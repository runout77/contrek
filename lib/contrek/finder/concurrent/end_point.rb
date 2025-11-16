module Contrek
  module Concurrent
    class EndPoint
      attr_reader :queues
      def initialize
        @queues = []
      end

      def inspect
        "EndPoint[#{@queues.size}]"
      end
    end
  end
end
