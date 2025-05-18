module Contrek
  module Bitmaps
    module Painting
      def draw_line(start_x, start_y, end_x, end_y, value)
        raise NoMethodError
      end

      def bitmap_colors(step: 1, max: 0)
        colors = {}
        step = 1 if step <= 0
        0.step(h - 1, step) do |h|
          0.step(w - 1, step) do |w|
            color = value_at(w, h)
            colors[color] ||= 0
            colors[color] += 1
            break if colors.size == max
          end
        end
        colors.sort_by { |color, count| -color }
      end

      def self.direct_draw_polygons(polygons, png_image)
        polygons.compact.each do |poly|
          color = ChunkyPNG::Color("red @ 1.0")
          poly[:outer].each_cons(2) do |coords|
            png_image.draw_line(coords[0][:x], coords[0][:y], coords[1][:x], coords[1][:y], color)
          end
          png_image.draw_line(poly[:outer][0][:x], poly[:outer][0][:y], poly[:outer][-1][:x], poly[:outer][-1][:y], color)
          color = ChunkyPNG::Color("green @ 1.0")
          poly[:inner].each do |sequence|
            sequence.each_cons(2) do |coords|
              png_image.draw_line(coords[0][:x], coords[0][:y], coords[1][:x], coords[1][:y], color)
            end
            png_image.draw_line(sequence[0][:x], sequence[0][:y], sequence[-1][:x], sequence[-1][:y], color)
          end
        end
      end
    end
  end
end
