# frozen_string_literal: true

module Contrek
  module Concurrent
    class GeoJsonStreamingMerger < StreamingMerger
      def initialize(stream_to:, pixel_val:, options: {})
        @pixel_val = pixel_val
        super(stream_to:, options:)
      end

      def write_header
        @first_feature = true
        @stream.write("{\"type\":\"FeatureCollection\",\"features\":[")
      end

      def write_footer
        @stream.write("]}")
      end

      def stream_raw_polygon(shape)
        if @first_feature
          @first_feature = false
        else
          @stream.write(",")
        end
        outer_ring = shape.outer_polyline.raw.map { |p| [p[:y], p[:x]] }
        outer_ring << outer_ring.first if outer_ring.first != outer_ring.last
        polygon_coordinates = [outer_ring]
        shape.inner_polylines.map(&:raw).each do |sequence|
          inner_ring = sequence.map { |p| [p[:y], p[:x]] }
          inner_ring << inner_ring.first if inner_ring.first != inner_ring.last
          polygon_coordinates << inner_ring
        end
        feature_hash = {
          type: "Feature",
          properties: {PixelVal: @pixel_val},
          geometry: {
            type: "Polygon",
            coordinates: polygon_coordinates
          }
        }
        @stream.write(JSON.generate(feature_hash))
      end
    end
  end
end
