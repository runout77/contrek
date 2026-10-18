# frozen_string_literal: true

module Contrek
  module Concurrent
    class MergerValidator
      def initialize(merger)
        @merger = merger
      end

      def validate(result, start_x, end_x)
        validate_bounds(result.polygons)
        validate_polygon_order(result.polygons)
        validate_boundary(result, start_x)

        @previous_boundary = boundary_coordinates(result.polygons, end_x)
      end

      def validate_metadata(result)
        metadata = result.metadata
        [:width, :height, :versus].each do |key|
          raise ArgumentError, "Missing result metadata: #{key}" unless metadata.key?(key)
        end
        [:width, :height].each do |key|
          value = metadata[key]
          unless value.is_a?(Integer) && value.positive?
            raise ArgumentError, "Invalid result metadata: #{key} must be a positive integer"
          end
        end
        unless [:a, :o].include?(metadata[:versus])
          raise ArgumentError, "Invalid result metadata: unsupported versus option"
        end
      end

      private

      def validate_polygon_order(polygons)
        previous = nil
        polygons.each do |polygon|
          bounds = polygon[:bounds]
          current = if @merger.transpose?
            [bounds[:min_x], bounds[:min_y]]
          else
            [bounds[:min_y], bounds[:min_x]]
          end
          if previous && (current <=> previous) < 0
            raise ArgumentError, "Invalid polygon order: polygons are not in raster scan order"
          end
          previous = current
        end
      end

      def validate_boundary(result, start_x)
        return unless @previous_boundary

        current = boundary_coordinates(result.polygons, start_x)
        unless @previous_boundary == current
          raise ArgumentError, "Tile boundary mismatch: adjacent tiles have different edge coordinates"
        end
      end

      def boundary_coordinates(polygons, boundary_x)
        coordinates = []
        polygons.each do |polygon|
          polygon[:outer].each do |point|
            coordinates << point[:y] if point[:x] == boundary_x
          end
        end
        coordinates.sort!
      end

      def validate_bounds(polygons)
        polygons.each do |polygon|
          outer = polygon[:outer]
          raise ArgumentError, "Invalid polygon: empty outer contour" if outer.empty?
          bounds = polygon[:bounds]
          min_x = max_x = outer[0][:x]
          min_y = max_y = outer[0][:y]
          outer.each do |point|
            x = point[:x]
            y = point[:y]
            min_x = x if x < min_x
            max_x = x if x > max_x
            min_y = y if y < min_y
            max_y = y if y > max_y
          end
          unless bounds[:min_x] == min_x &&
              bounds[:max_x] == max_x &&
              bounds[:min_y] == min_y &&
              bounds[:max_y] == max_y
            raise ArgumentError, "Invalid polygon bounds: bounding box does not match outer contour"
          end
        end
      end
    end
  end
end
