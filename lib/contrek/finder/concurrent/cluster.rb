module Contrek
  module Concurrent
    class Cluster
      attr_reader :tiles, :hub

      def initialize(finder:, height:, start_x:, end_x:)
        @finder = finder
        @tiles = []
        @hub = Hub.new(start_x:, end_x:)
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
        tot_inner = 0
        tot_outer = 0

        new_shapes = []
        tot_outer += Benchmark.measure do
          @tiles.each do |tile|
            tile.shapes.each do |shape|
              next if shape.outer_polyline.on?(Polyline::TRACKED_OUTER) || shape.outer_polyline.width == 0
              if shape.outer_polyline.boundary?
                shape.outer_polyline.partition!
                shape.outer_polyline.precalc!
              end
            end
          end
        end.real

        @tiles.each do |tile|
          tile.shapes.each do |shape|
            next if shape.outer_polyline.on?(Polyline::TRACKED_OUTER) || shape.outer_polyline.width == 0

            if shape.outer_polyline.boundary? && shape.outer_polyline.next_tile_eligible_shapes.any?
              new_outer = nil
              new_inners = shape.inner_polylines
              cursor = Cursor.new(cluster: self, shape: shape)

              tot_outer += Benchmark.measure do
                new_outer = cursor.join_outers!
              end.real
              tot_inner += Benchmark.measure do
                new_inner_sequences = cursor.join_inners!(new_outer)
                new_inners += new_inner_sequences.map { |s| s.to_a } if new_inner_sequences.any?
                new_inners += cursor.orphan_inners
              end.real

              new_shapes << Shape.new.tap do |shape|
                polyline = Polyline.new(tile: tile, polygon: new_outer.to_a)
                shape.outer_polyline = polyline
                polyline.shape = shape
                shape.inner_polylines = new_inners
              end
            else
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
    end
  end
end
