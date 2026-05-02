module Contrek
  module Concurrent
    class Polyline
      prepend Partitionable

      TRACKED_OUTER = 1 << 0

      attr_reader :raw, :name, :min_y, :max_y
      attr_accessor :shape, :tile, :any_ancients

      def initialize(tile:, polygon:, shape: nil, bounds: nil)
        @tile = tile
        @name = tile.shapes.count
        @raw = polygon
        @shape = shape
        @flags = 0
        @any_ancients = false

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

      def vert_intersect?(other)
        !(@max_y < other.min_y || other.max_y < @min_y)
      end

      def vert_bounds_intersect?(vertical_bounds)
        !(@max_y < vertical_bounds[:min] || vertical_bounds[:max] < @min_y)
      end

      # verifies if enclosed in the given sequence (raycasting technique)
      def within?(raw_coords)
        is_within = false
        self_y = raw.first[:y]
        self_x = raw.first[:x]
        last_node = raw_coords.last
        return false if last_node.nil?
        lx = last_node[:x]
        ly = last_node[:y]
        raw_coords.each do |pos|
          cx = pos[:x]
          cy = pos[:y]
          if (cy > self_y) != (ly > self_y)
            intersect_x = lx + (self_y - ly).to_f * (cx - lx) / (cy - ly)
            if self_x < intersect_x
              is_within = !is_within
            end
          end
          lx, ly = cx, cy
        end
        is_within
      end

      def get_bounds
        {min_x: @min_x,
         max_x: @max_x,
         min_y: @min_y,
         max_y: @max_y}
      end

      def self.is_within?(test_seq, container_seq)
        target = test_seq.first
        return false unless target
        tx, ty = target[:x], target[:y]
        inside = false
        j = container_seq.length - 1
        container_seq.each_with_index do |p_i, i|
          p_j = container_seq[j]
          if (p_i[:y] > ty) != (p_j[:y] > ty)
            intersect_x = (p_j[:x] - p_i[:x]) * (ty - p_i[:y]).to_f / (p_j[:y] - p_i[:y]) + p_i[:x]
            if tx < intersect_x
              inside = !inside
            end
          end
          j = i
        end
        inside
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
