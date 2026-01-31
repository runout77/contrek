module Contrek
  module Concurrent
    class Position
      include Listable

      attr_reader :end_point

      def initialize(hub:, position:)
        @end_point = hub.payloads[position[:y]] ||= EndPoint.new if hub
        @position = position
      end

      def payload
        @position
      end

      def after_add(new_queue)
        @end_point.queues << new_queue if @end_point
      end

      def before_rem(old_queue)
        @end_point&.queues&.delete(old_queue)
      end
    end
  end
end
