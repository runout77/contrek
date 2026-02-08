module Contrek
  module Concurrent
    class Polyline
      prepend Partitionable

      TRACKED_OUTER = 1 << 0
      TRACKED_INNER = 1 << 1

      attr_reader :raw, :name, :min_y, :max_y, :next_tile_eligible_shapes
      attr_accessor :shape, :tile, :mixed_tile_origin

      def initialize(tile:, polygon:, shape: nil, bounds: nil)
        @tile = tile
        @name = tile.shapes.count
        @raw = polygon
        @shape = shape
        @flags = 0
        @mixed_tile_origin = false # becomes true when is sewn with polyline coming from other side tile

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
        "#{self.class}#{named} (#{raw.count} => #{raw.inspect})"
      end

      def named
        "[b#{@tile.name} S#{@name} #{"B" if boundary?}]"
      end

      def numpy_raw
        raw.flat_map { |p| [p[:x], p[:y]] }
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

      def reset_tracked_endpoints!
        @tracked_endpoints = nil
      end

      # returns for every position of intersection an array composed by the indexes of parts (self,other) involved
      # es [[1,3],[2,6],...]. The first time the sequence for self is computed is stored.
      def intersection(other)
        if @tracked_endpoints.nil?
          @tracked_endpoints = {} # memoize found sequence
          parts.each_with_index do |part, part_index|
            next if !part.is?(Part::SEAM) && part.trasmuted
            part.each do |pos|
              next if pos.end_point.nil?
              @tracked_endpoints[pos.end_point.object_id] = part_index
            end
          end
        end
        matching_parts = []
        other.parts.each_with_index do |part, part_index|
          next if !part.is?(Part::SEAM) && part.trasmuted
          part.each do |pos|
            if (self_index = @tracked_endpoints[pos.end_point.object_id])
              matching_parts << [self_index, part_index]
              false
            else
              true
            end
          end
        end
        matching_parts
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

      def get_bounds
        {min_x: @min_x,
         max_x: @max_x,
         min_y: @min_y,
         max_y: @max_y}
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
