module Contrek
  module Concurrent
    class Merger < Finder
      prepend Poolable

      def initialize(options: {})
        @initialize_time = 0
        @current_x = 0
        @tiles = Queue.new
        @whole_tile = nil
        @options = options
      end

      def add_tile(result)
        @height ||= result.metadata[:height]
        end_x = @current_x + result.metadata[:width]

        tile = Tile.new(
          finder: self,
          start_x: @current_x,
          end_x: end_x,
          name: @tiles.size.to_s
        )
        tile.assign_raw_polygons!(result[:polygons])

        @tiles << tile
        @maximum_width = end_x
        @current_x = end_x - 1
      end

      def process_info
        process_tiles!(nil, height: @height)
        super
      end

      private

      def translate(result, offset)
        result.polygons.each do |polygon|
          polygon[:outer].each { |p| p[:x] += offset }
          polygon[:inner].each do |sequence|
            sequence.each { |p| p[:x] += offset }
          end
          if polygon.key?(:bounds)
            polygon[:bounds][:min_x] += offset
            polygon[:bounds][:max_x] += offset
          end
        end
      end
    end
  end
end
