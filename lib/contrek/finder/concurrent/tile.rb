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
        assign_raw_polygons!(result[:polygons], result.metadata[:treemap])
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
        shapes.each do |s|
          s.outer_polyline.tile = self
        end
        @shapes = shapes
      end

      def to_raw_polygons
        @shapes.filter_map do |shape|
          unless shape.outer_polyline.empty?
            {outer: shape.outer_polyline.raw,
             inner: shape.inner_polylines.map(&:raw)}
          end
        end
      end

      def compute_treemap
        @shapes_map = {}
        shape_index = 0

        @shapes.map do |shape|
          next if shape.outer_polyline.empty?
          @shapes_map[shape] = shape_index
          shape_index += 1
          if shape.parent_shape
            [@shapes_map[shape.parent_shape], shape.parent_shape.inner_polylines.index(shape.parent_inner_polyline)]
          else
            [-1, -1]
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

      def assign_raw_polygons!(raw_polylines, treemap = nil)
        @shapes = []
        shapes_map = {}
        raw_polylines.each_with_index do |raw_polyline, polyline_index|
          next if raw_polyline[:bounds][:max_x] - raw_polyline[:bounds][:min_x] == 0
          shape = Shape.new.tap do |shape|
            shape.outer_polyline = Polyline.new(tile: self, polygon: raw_polyline[:outer], shape: shape, bounds: raw_polyline[:bounds])
            shape.inner_polylines = raw_polyline[:inner].map { |raw| InnerPolyline.new(shape: shape, raw_coordinates: raw) }
          end
          @shapes << shape

          if treemap && (treemap_entry = treemap[polyline_index])
            shapes_map[polyline_index] = shape
            if treemap_entry != [-1, -1]
              parent = shapes_map[treemap_entry.first]
              shape.set_parent_shape(parent)
              shape.parent_inner_polyline = parent.inner_polylines[treemap_entry.last]
            end
          end
        end
      end
    end
  end
end
