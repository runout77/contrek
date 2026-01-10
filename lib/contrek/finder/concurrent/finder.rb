module Contrek
  module Concurrent
    class Finder
      prepend Poolable

      attr_reader :maximum_width

      # Supported options
      # - number_of_threads: number of threads that can be used by the process. If set to 0, it works in
      #   single-thread mode.
      #   The process can take advantage of multiprocessing when computing the initial contours of the
      #   tiles into which the image is divided, and during the subsequent merging of tiles into pairs.
      #   Each merge is performed by any available thread as soon as two adjacent tiles have been computed.
      #   If set to nil, the process will use the maximum number of cpu available cores.
      # - bitmap: PngBitmap containing the image.
      # - matcher: specific Matcher used for pixel identification.
      # - options: options include:
      #            - number_of_tiles: number of tiles into which the image is initially divided.
      #              It cannot exceed the image width, so the system works with tiles at least one pixel wide.
      #              Given the technique on which the process is based, using excessively narrow tiles is
      #              discouraged.

      def initialize(bitmap:, matcher:, options: {}, &block)
        @initialize_time = Benchmark.measure do
          @block = block
          @tiles = Queue.new
          @whole_tile = nil
          @options = options
          @clusters = []
          @maximum_width = bitmap.w
          @number_of_tiles = options[:number_of_tiles] || (raise "number_of_tiles params is needed!")

          cw = @maximum_width.to_f / @number_of_tiles
          raise "One pixel tile width minimum!" if cw < 1.0
          x = 0
          current_versus = options[:versus]
          raise "Define versus!" if current_versus.nil?

          @number_of_tiles.times do |tile_index|
            tile_end_x = (cw * (tile_index + 1)).to_i

            enqueue!(tile_index: tile_index,
              tile_start_x: x,
              tile_end_x: tile_end_x) do |payload|
              finder = ClippedPolygonFinder.new(
                bitmap: bitmap,
                matcher: matcher,
                options: {versus: current_versus, bounds: true},
                start_x: payload[:tile_start_x],
                end_x: payload[:tile_end_x]
              )
              tile = Tile.new(
                finder: self,
                start_x: payload[:tile_start_x],
                end_x: payload[:tile_end_x],
                name: payload[:tile_index].to_s
              )
              tile.initial_process!(finder)
              @tiles << tile
            end

            x = tile_end_x - 1
          end
          process_tiles!(bitmap)
        end.real
      end

      def process_info(bitmap = nil)
        raw_polygons = @whole_tile.to_raw_polygons

        compress_time = Benchmark.measure do
          if @options.has_key?(:compress)
            FakeCluster.new(raw_polygons, @options).compress_coords
          end
        end.real

        metadata = {
          groups: raw_polygons.size,
          benchmarks: {
            total: ((@initialize_time + compress_time) * 1000).round(3),
            init: (@initialize_time * 1000).round(3),
            outer: (@whole_tile.benchmarks[:outer] * 1000).round(3),
            inner: (@whole_tile.benchmarks[:inner] * 1000).round(3),
            compress: ((compress_time * 1000).round(3) if @options.has_key?(:compress))
          }.compact
        }
        Contrek::Finder::Result.new(raw_polygons, metadata)
      end

      private

      def process_tiles!(bitmap)
        arriving_tiles = []
        loop do
          tile = @tiles.pop
          if tile.whole?
            @whole_tile = tile
            return
          end
          if (twin_tile = arriving_tiles.find { |b| (b.start_x == (tile.end_x - 1)) || ((b.end_x - 1) == tile.start_x) })
            cluster = Cluster.new(finder: self, height: bitmap.h, width: bitmap.w)
            if twin_tile.start_x == (tile.end_x - 1)
              cluster.add(tile)
              cluster.add(twin_tile)
            else
              cluster.add(twin_tile)
              cluster.add(tile)
            end
            enqueue!(cluster: cluster) do |payload|
              merged_tile = payload[:cluster].merge_tiles!
              @tiles << merged_tile
              # usefull external access to each merged_tile
              @block&.call(merged_tile, bitmap)
            end
            arriving_tiles.delete(twin_tile)
            next
          end
          arriving_tiles << tile
        end
      end
    end
  end
end
