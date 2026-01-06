module Contrek
  module Concurrent
    class Tile
      attr_reader :start_x, :end_x, :benchmarks, :shapes, :name
      attr_accessor :prev, :next, :circular_next, :cluster

      def initialize(finder:, start_x:, end_x:, name:, benchmarks: {})
        @finder = finder
        @start_x = start_x
        @end_x = end_x
        @name = name
        @prev = nil
        @next = nil
        @benchmarks = {outer: 0, inner: 0}.merge(benchmarks)
      end

      def whole?
        @start_x == 0 && @end_x == @finder.maximum_width
      end

      def left?
        @start_x == 0
      end

      def right?
        @end_x == @finder.maximum_width
      end

      def initial_process!(finder)
        result = finder.process_info
        assign_raw_polygons!(result[:polygons])
      end

      def boundary_shapes
        @bbs ||= shapes.select { |s| s.outer_polyline.boundary? }
      end

      def iterate
        @shapes.each do |shape|
          shape.outer_polyline.raw.each do |position|
            yield(position, "O")
          end
          shape.inner_polylines.each do |inner|
            inner.each do |position|
              yield(position, "I")
            end
          end
        end
      end

      def assign_shapes!(shapes)
        shapes.each { |s| s.outer_polyline.tile = self }
        @shapes = shapes
      end

      def to_raw_polygons
        @shapes.filter_map do |shape|
          unless shape.outer_polyline.empty?
            {outer: shape.outer_polyline.raw,
             inner: shape.inner_polylines}
          end
        end
      end

      def info
        {name: @name, start_x: @start_x, end_x: @end_x}
      end

      def tg_border?(coord)
        coord[:x] == (@next.nil? ? @start_x : (@end_x - 1))
      end

      def inspect
        "#{self.class}[#{@name}]"
      end

      private

      def assign_raw_polygons!(raw_polylines)
        @shapes = []
        raw_polylines.each do |raw_polyline|
          next if raw_polyline[:bounds][:max_x] - raw_polyline[:bounds][:min_x] == 0
          @shapes << Shape.new.tap do |shape|
            shape.outer_polyline = Polyline.new(tile: self, polygon: raw_polyline[:outer], shape: shape, bounds: raw_polyline[:bounds])
            shape.inner_polylines = raw_polyline[:inner]
          end
        end
      end
    end
  end
end
