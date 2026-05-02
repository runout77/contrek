module Contrek
  module Concurrent
    class EndPoint
      attr_reader :queues, :position
      attr_accessor :tracked_outer
      def initialize(position)
        @queues = []
        @position = position
        @tracked_outer = false
      end

      def inspect
        "EndPoint[#{@queues.size}]"
      end
    end
  end
end
