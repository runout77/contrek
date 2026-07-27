# frozen_string_literal: true

module Contrek
  module Concurrent
    class StreamingMerger < VerticalMerger
      def initialize(stream_to:, options: {})
        @stream = stream_to
        @moved = 0
        super(options: options)
      end

      def add_tile(result, flush = false)
        super(result)

        if @tiles.size == 2
          process_tiles!(nil, height: @height)
          @tiles << @whole_tile
          stream_polygons!(@whole_tile, flush)
        end
      end

      def process_info
        result = super
        result.metadata[:groups] = @moved
        result
      end

      private

      def stream_polygons!(tile, flush = false)
        ensure_header

        tile.shapes.select! do |shape|
          bounds = shape.outer_polyline.get_bounds
          if flush || bounds[:max_x] < tile.end_x - 1
            @moved += 1
            polygon = shape.to_raw_polygon
            if @options.has_key?(:compress)
              FakeCluster.new([polygon], @options).compress_coords
            end
            stream_raw_polygon(polygon)
            false
          else
            true
          end
        end

        ensure_footer if flush
      end

      def stream_raw_polygon(polygon)
        outer_pts = polygon[:outer].map { |p| "#{p[:y]},#{p[:x]}" }.join(" ")
        write_outer_polygon(outer_pts)
        polygon[:inner].each do |sequence|
          inner_pts = sequence.map { |p| "#{p[:y]},#{p[:x]}" }.join(" ")
          write_inner_polygon(inner_pts)
        end
      end

      def ensure_header
        if @stream.pos == 0
          write_header
        end
      end

      def ensure_footer
        write_footer
      end
    end
  end
end
