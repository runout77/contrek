# frozen_string_literal: true

module Contrek
  module Concurrent
    class Cluster
      attr_reader :tiles, :hub, :finder

      def initialize(finder:, height:, start_x:, end_x:)
        @finder = finder
        @tiles = []
        @hub = Hub.new(height:)
      end

      def add(tile)
        last_tile = @tiles.last
        last_tile.next = last_tile.circular_next = tile if last_tile
        @tiles << tile
        tile.prev = last_tile
        tile.circular_next = last_tile
        tile.cluster = self
      end

      # Here, two tiles are merged into a single one. The tile is assigned new shapes composed of the detected
      # outer sequences and both the old and new inner ones. Shapes that are not in the contact area are directly
      # reassigned unchanged to the new shape.
      def merge_tiles!
        treemap = @finder.options[:treemap]
        tot_inner = 0
        tot_outer = 0

        new_shapes = []
        all_new_inner_polylines = []

        tot_outer += Benchmark.measure do
          @tiles.each do |tile|
            tile.shapes.each do |shape|
              next if shape.outer_polyline.on?(Polyline::TRACKED_OUTER) || shape.outer_polyline.width == 0
              if shape.outer_polyline.boundary?
                shape.outer_polyline.partition!
              end
            end
          end
        end.real

        @tiles.each do |tile|
          tile.shapes.each do |shape|
            next if shape.outer_polyline.on?(Polyline::TRACKED_OUTER) || shape.outer_polyline.width == 0

            if shape.outer_polyline.any_ancients
              cursor = Cursor.new(cluster: self, shape: shape)

              new_outer = nil
              tot_outer += Benchmark.measure do
                new_outer = cursor.join_outers!
              end.real

              new_inners = shape.inner_polylines
              new_inner_polylines = []
              tot_inner += Benchmark.measure do
                new_inner_polylines = cursor.join_inners!(treemap)
                new_inners += new_inner_polylines
                if treemap
                  new_inner_polylines.each do |inner_polyline|
                    inner_polyline.compute_vertical_bounds!
                    all_new_inner_polylines += new_inner_polylines
                  end
                end
                new_inners += cursor.orphan_inners
              end.real

              polyline = Polyline.new(tile: tile, polygon: new_outer.to_a)
              inserting_new_shape = Shape.init_by(polyline, new_inners)
              new_shapes << inserting_new_shape
              polyline.shape = inserting_new_shape

              new_inner_polylines.each { |inner_polyline| inner_polyline.shape = inserting_new_shape }

              if treemap
                cursor.shapes_sequence.each do |merged_shape|
                  merged_shape.merged_to_shape = inserting_new_shape
                end
                if shape.outer_polyline.inside_inner_polyline
                  assign_ancestry(inserting_new_shape, shape.outer_polyline.inside_inner_polyline)
                end
              end
            else
              if treemap
                if shape.fixed
                  shape.set_parent_shape(shape.parent_shape.merged_to_shape) if shape.parent_shape.merged_to_shape
                else
                  is_children(shape, all_new_inner_polylines)
                end
              end

              new_shapes << shape
            end
          end
        end

        past_tot_outer = @tiles.first.benchmarks[:outer] + @tiles.last.benchmarks[:outer]
        past_tot_inner = @tiles.first.benchmarks[:inner] + @tiles.last.benchmarks[:inner]

        tile = Tile.new(
          finder: @finder,
          start_x: @tiles.first.start_x,
          end_x: @tiles.last.end_x,
          benchmarks: {outer: tot_outer + past_tot_outer, inner: tot_inner + past_tot_inner},
          name: @tiles.first.name + @tiles.last.name
        )

        tile.assign_shapes!(new_shapes)
        tile
      end

      private

      def assign_ancestry(shape, inner_polyline)
        shape.set_parent_shape(inner_polyline.shape)
        shape.parent_inner_polyline = inner_polyline
        shape.fixed = true
      end

      def is_children(shape, inner_polylines)
        inner_polylines.each do |inner_polyline|
          bounds = inner_polyline.vertical_bounds
          min_y = bounds[:min]
          max_y = bounds[:max]
          next if shape.outer_polyline.get_bounds[:max_y] < min_y ||
            shape.outer_polyline.get_bounds[:min_y] > max_y
          if shape.outer_polyline.within?(inner_polyline.raw)
            assign_ancestry(shape, inner_polyline)
          end
        end
      end
    end
  end
end
