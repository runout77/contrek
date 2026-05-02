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
          invert_point = ->(p) { {x: p[:y], y: p[:x]} }
          polygon[:outer] = polygon[:outer].map(&invert_point)
          polygon[:inner] = polygon[:inner].map do |sequence|
            sequence.map(&invert_point)
          end
          if polygon.key?(:bounds)
            b = polygon[:bounds]
            polygon[:bounds] = {
              min_x: b[:min_y], min_y: b[:min_x],
              max_x: b[:max_y], max_y: b[:max_x]
            }
          end
        end
        result
      end
    end
  end
end
