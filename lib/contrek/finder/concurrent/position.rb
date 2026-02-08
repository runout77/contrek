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
        @end_point.queues << new_queue if @end_point
      end

      def before_rem(old_queue)
        @end_point&.queues&.delete(old_queue)
      end

      def inspect
        "#{self.class} (#{payload})"
      end
    end
  end
end
