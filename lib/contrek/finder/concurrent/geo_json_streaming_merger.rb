# frozen_string_literal: true

module Contrek
  module Concurrent
    class GeoJsonStreamingMerger < StreamingMerger
      def initialize(stream_to:, pixel_val:, options: {})
        @pixel_val = pixel_val
        @point_converter = self.class.coordinates_converter(options[:geo_localization])

        super(stream_to:, options:)
      end

      def write_header
        @first_feature = true
        @stream.write("{\"type\":\"FeatureCollection\",\"features\":[")
      end

      def write_footer
        @stream.write("]}")
      end

      def stream_raw_polygon(polygon)
        if @first_feature
          @first_feature = false
        else
          @stream.write(",")
        end
        outer_ring = polygon[:outer].map { |p| @point_converter.call(p) }
        outer_ring << outer_ring.first if outer_ring.first != outer_ring.last
        polygon_coordinates = [outer_ring]
        polygon[:inner].each do |sequence|
          inner_ring = sequence.map { |p| @point_converter.call(p) }
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

      def self.coordinates_converter(geo_localization)
        return ->(point) { [point[:y], point[:x]] } unless geo_localization

        crs = geo_localization[:crs]
        raise "Unsupported CRS: #{crs[:authority]}:#{crs[:code]}" unless crs[:authority] == "EPSG" && crs[:code] == 4326

        transform = geo_localization[:transform]
        lambda do |point|
          x = point[:y]
          y = point[:x]
          [(transform[:x_origin] + x * transform[:x_pixel_size] + y * transform[:x_row_offset]).round(7),
            (transform[:y_origin] + x * transform[:y_column_offset] + y * transform[:y_pixel_size]).round(7)]
        end
      end
    end
  end
end
