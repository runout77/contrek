module Contrek
  module Concurrent
    class Polyline
      prepend Partitionable

      TRACKED_OUTER = 1 << 0
      TRACKED_INNER = 1 << 1

      attr_reader :raw, :name, :min_y, :max_y, :next_tile_eligible_shapes
      attr_accessor :shape, :tile

      def initialize(tile:, polygon:, shape: nil, bounds: nil)
        @tile = tile
        @name = tile.shapes.count
        @raw = polygon
        @shape = shape
        @flags = 0

        if bounds.nil?
          find_boundary
        else
          @min_x = bounds[:min_x]
          @max_x = bounds[:max_x]
          @min_y = bounds[:min_y]
          @max_y = bounds[:max_y]
        end
      end

      def inspect
        "#{self.class}[b#{@tile.name} S#{@name} #{"B" if boundary?}] (#{raw.count} => #{raw.inspect})"
      end

      def info
        "w#{@tile.name} S#{@name}"
      end

      def turn_on(flag)
        @flags |= flag
      end

      def turn_off(flag)
        @flags &= ~flag
      end

      def on?(flag)
        (@flags & flag) != 0
      end

      def intersection(other)
        @raw & other.raw
      end

      def empty?
        @raw.empty?
      end

      def boundary?
        @tile.tg_border?({x: @min_x}) || @tile.tg_border?({x: @max_x})
      end

      def clear!
        @raw = []
      end

      def width
        return 0 if empty?
        @max_x - @min_x
      end

      # Pre-detects, for the current polyline, adjacent ones in the neighboring tile
      # that vertically intersect.
      def precalc!
        @next_tile_eligible_shapes = @tile
          .circular_next.boundary_shapes
          .select { |s|
          !s.outer_polyline.on?(Polyline::TRACKED_OUTER) &&
            vert_intersect?(s.outer_polyline)
        }
      end

      def vert_intersect?(other)
        !(@max_y < other.min_y || other.max_y < @min_y)
      end

      private

      def find_boundary
        return if @raw.empty?

        bounds = @raw.each_with_object(Bounds.empty) do |c, b|
          b.expand(x: c[:x], y: c[:y])
        end
        @min_x, @max_x, @min_y, @max_y = bounds.values
      end
    end
  end
end
