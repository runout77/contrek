# frozen_string_literal: true

module Contrek
  module Concurrent
    class InnerPolyline
      attr_reader :raw, :vertical_bounds
      attr_accessor :shape

      def initialize(shape: nil, raw_coordinates: [], sequence: nil)
        if sequence
          @shape = sequence.shape
          @raw = sequence.to_a
        else
          @shape = shape
          @raw = raw_coordinates
        end
      end

      def compute_vertical_bounds!
        @vertical_bounds ||= begin
          min_y = Float::INFINITY
          max_y = 0
          @raw.each do |pos|
            y = pos[:y]
            min_y = y if y < min_y
            max_y = y if y > max_y
          end
          {min: min_y, max: max_y}
        end
      end
    end
  end
end
