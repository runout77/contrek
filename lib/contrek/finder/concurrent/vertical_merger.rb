# frozen_string_literal: true

module Contrek
  module Concurrent
    class VerticalMerger < Merger
      def add_tile(result)
        transpose(result)
        adjust(result)
        if @tiles.size > 0
          translate(result, @current_x)
        end
        super
      end

      def process_info(flush: false)
        transpose(super())
      end

      def transpose?
        true
      end

      private

      # After transposing the polygon, select the correct starting vertex according to its versus.
      # On the topmost scanline, use the rightmost vertex for counterclockwise polygons and the leftmost
      # vertex for clockwise polygons.
      # TODO: is useless the really rotate coords. Probably you can save rotation index here computed
      #       using later in partition() to get the starting point sequence parts begins
      def adjust(result)
        versus = result.metadata[:versus]
        tile_width = result.metadata[:width]
        number_of_tiles = @tiles.size

        result.polygons.each do |polygon|
          bounds = polygon[:bounds]
          needs_left = number_of_tiles > 0 && bounds[:min_x] == 0
          needs_right = bounds[:max_x] == tile_width
          next unless needs_left || needs_right
          sequence = polygon[:outer]
          index = nil
          best_x = nil
          sequence.each_with_index do |point, i|
            next unless point[:y] == bounds[:min_y]
            if index.nil? || ((versus == :a) ? point[:x] > best_x : point[:x] < best_x)
              index = i
              best_x = point[:x]
            end
          end
          sequence.rotate!(index) if index && index != 0
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
