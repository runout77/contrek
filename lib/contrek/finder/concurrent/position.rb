module Contrek
  module Concurrent
    class Position
      include Listable

      attr_reader :end_point

      def initialize(hub:, position:)
        key = position[:y] * hub.width + position[:x]
        @end_point = hub.payloads[key] ||= EndPoint.new
        @position = position
      end

      def payload
        @position
      end

      def after_add(new_queue)
        @end_point.queues << new_queue
      end

      def before_rem(old_queue)
        @end_point.queues.delete(old_queue)
      end
    end
  end
end
