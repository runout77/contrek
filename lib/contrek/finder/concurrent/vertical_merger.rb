module Contrek
  module Concurrent
    class VerticalMerger < Merger
      def add_tile(result)
        transpose(result)
        if @tiles.size > 0
          translate(result, @current_x)
        end
        adjust(result)
        super
      end

      def process_info
        transpose(super)
      end

      private

      def adjust(result)
        result.polygons.each do |polygon|
          polygon[:outer].rotate!(1)
          polygon[:inner].each do |sequence|
            sequence.rotate!(1)
          end
        end
      end

      def transpose(result)
        result.metadata[:width], result.metadata[:height] = result.metadata[:height], result.metadata[:width]
        result.polygons.each do |polygon|
          polygon[:outer].each { |p| p[:x], p[:y] = p[:y], p[:x] }
          polygon[:inner].each do |sequence|
            sequence.each { |p| p[:x], p[:y] = p[:y], p[:x] }
          end
          if polygon.key?(:bounds)
            polygon[:bounds][:min_x], polygon[:bounds][:min_y] = polygon[:bounds][:min_y], polygon[:bounds][:min_x]
            polygon[:bounds][:max_x], polygon[:bounds][:max_y] = polygon[:bounds][:max_y], polygon[:bounds][:max_x]
          end
        end
        result
      end
    end
  end
end
