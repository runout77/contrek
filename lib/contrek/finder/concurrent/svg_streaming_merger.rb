# frozen_string_literal: true

module Contrek
  module Concurrent
    class SvgStreamingMerger < StreamingMerger
      def initialize(stream_to:, total_width:, total_height:, options: {})
        @total_width = total_width
        @total_height = total_height
        super(stream_to:, options:)
      end

      def write_header
        @stream.write("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"#{@total_width}\" height=\"#{@total_height}\"><style>#{svg_css}</style>")
      end

      def write_footer
        @stream.write("</svg>")
      end

      def write_outer_polygon(outer_pts)
        @stream.write("<polygon points=\"#{outer_pts}\" class=\"out\"/>")
      end

      def write_inner_polygon(inner_pts)
        @stream.write("<polygon points=\"#{inner_pts}\" class=\"in\"/>")
      end

      private

      def svg_css
        ".out{fill:none;stroke:red;stroke-width:1;}.in{fill:none;stroke:green;stroke-width:1;}.out:hover{stroke:yellow;}"
      end
    end
  end
end
