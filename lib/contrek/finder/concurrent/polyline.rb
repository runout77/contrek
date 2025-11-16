module Contrek
  module Concurrent
    class Polyline
      prepend Partitionable

      TRACKED_OUTER = 1 << 0
      TRACKED_INNER = 1 << 1
      Bounds = Struct.new(:min_x, :max_x, :min_y, :max_y)

      attr_reader :raw, :name, :min_y, :max_y, :next_tile_eligible_shapes
      attr_accessor :shape, :tile

      def initialize(tile:, polygon:, shape: nil)
        @tile = tile
        @name = tile.shapes.count
        @raw = polygon
        @shape = shape
        @flags = 0
        find_boundary
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
        (@raw.compact & other.raw.compact)
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

      def vert_intersect?(other)
        !(@max_y < other.min_y || other.max_y < @min_y)
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

      private

      def find_boundary
        return if @raw.empty?

        bounds = @raw.compact.each_with_object(Bounds.new(Float::INFINITY, -Float::INFINITY, Float::INFINITY, -Float::INFINITY)) do |c, b|
          x, y = c[:x], c[:y]
          b.min_x = x if x < b.min_x
          b.max_x = x if x > b.max_x
          b.min_y = y if y < b.min_y
          b.max_y = y if y > b.max_y
        end

        @min_x, @max_x, @min_y, @max_y = bounds.values
      end
    end
  end
end
