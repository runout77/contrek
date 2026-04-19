module Contrek
  module Concurrent
    class Sequence
      attr_accessor :vertical_bounds, :shape
      prepend Queueable

      def initialize
        @vertical_bounds = nil
      end

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

      def compute_vertical_bounds!
        return if size == 0
        min_y = Float::INFINITY
        max_y = 0
        get_vector_cache.each do |pos|
          y = pos[:y]
          min_y = y if y < min_y
          max_y = y if y > max_y
        end
        @vertical_bounds = {min: min_y, max: max_y}
      end

      def get_vector_cache
        @vector_cache ||= to_a
      end
    end
  end
end
