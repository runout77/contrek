module Contrek
  module Concurrent
    class InnerPolyline
      attr_reader :sequence, :recombined

      def initialize(shape: nil, raw_coordinates: [], sequence: nil, recombined: false)
        @raw = raw_coordinates if raw_coordinates
        @sequence = sequence if sequence
        @recombined = recombined
        @shape = shape
      end

      def raw
        @sequence ? @sequence.to_a : @raw
      end

      def vertical_bounds
        if @sequence
          @sequence.vertical_bounds
        else
          raw_vertical_bounds
        end
      end

      def shape
        if @sequence
          @sequence.shape
        else
          @shape
        end
      end

      private

      def raw_vertical_bounds
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
