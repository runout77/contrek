# frozen_string_literal: true

module Contrek
  module Concurrent
    class StreamingMerger < VerticalMerger
      def initialize(stream_to:, total_width:, total_height:, options: {})
        @stream = stream_to
        @total_width = total_width
        @total_height = total_height
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
            stream_raw_polygon(shape)
            false
          else
            true
          end
        end

        ensure_footer if flush
      end

      def stream_raw_polygon(shape)
        outer_pts = shape.outer_polyline.raw.map { |p| "#{p[:y]},#{p[:x]}" }.join(" ")
        @stream.write(svg_outer_polygon(outer_pts))
        shape.inner_polylines.map(&:raw).each do |sequence|
          inner_pts = sequence.map { |p| "#{p[:y]},#{p[:x]}" }.join(" ")
          @stream.write(svg_inner_polygon(inner_pts))
        end
      end

      def ensure_header
        if @stream.pos == 0
          @stream.write(svg_header)
        end
      end

      def ensure_footer
        @stream.write(svg_footer)
      end

      def svg_footer
        "</svg>"
      end

      def svg_header
        "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"#{@total_width}\" height=\"#{@total_height}\"><style>#{svg_css}</style>"
      end

      def svg_outer_polygon(outer_pts)
        "<polygon points=\"#{outer_pts}\" class=\"out\"/>"
      end

      def svg_inner_polygon(inner_pts)
        "<polygon points=\"#{inner_pts}\" class=\"in\"/>"
      end

      def svg_css
        ".out{fill:none;stroke:red;stroke-width:1;}.in{fill:none;stroke:green;stroke-width:1;}.out:hover{stroke:yellow;}"
      end
    end
  end
end
