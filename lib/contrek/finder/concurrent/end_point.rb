module Contrek
  module Concurrent
    class EndPoint
      attr_reader :queues, :position
      def initialize(position)
        @queues = []
        @position = position
      end

      def inspect
        "EndPoint[#{@queues.size}]"
      end
    end
  end
end
