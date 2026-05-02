module Contrek
  module Concurrent
    class Position
      include Listable

      attr_reader :end_point

      def initialize(hub:, position:, known_endpoint: nil)
        if !known_endpoint.nil?
          @end_point = known_endpoint
          @position = @end_point.position
        else
          @end_point = hub.payloads[position[:y]] ||= EndPoint.new(position) if hub
          @position = position
        end
      end

      def payload
        @position
      end

      def after_add(new_queue)
        if @end_point && new_queue.instance_of?(Contrek::Concurrent::Part)
          @end_point.queues << new_queue if !@end_point.queues.include?(new_queue)
          if @end_point.queues.size > 1
            new_queue.polyline.any_ancients = true
            @end_point.queues.first.polyline.any_ancients = true
          end
        end
      end

      def before_rem(old_queue)
        # @end_point&.queues&.delete(old_queue) if old_queue.class == Contrek::Concurrent::Part
      end

      def inspect
        "#{self.class} (#{payload})"
      end
    end
  end
end
