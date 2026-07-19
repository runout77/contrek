# frozen_string_literal: true

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

      def self.direct_draw_polygons(polygons, png_image, zoom: 1)
        polygons.compact.each do |poly|
          if (bounds = poly[:bounds])
            b_factor = 3.to_f / zoom
            bounds_polygon = [
              {x: bounds[:min_x] - b_factor, y: bounds[:min_y] - b_factor},
              {x: bounds[:max_x] + b_factor, y: bounds[:min_y] - b_factor},
              {x: (bounds[:max_x] + b_factor), y: bounds[:max_y] + b_factor},
              {x: (bounds[:min_x] - b_factor), y: bounds[:max_y] + b_factor}
            ]
            draw_polygon(bounds_polygon, png_image, ChunkyPNG::Color("blue @ 1.0"), zoom)
          end
          color = ChunkyPNG::Color("red @ 1.0")
          draw_polygon(poly[:outer], png_image, color, zoom)
          color = ChunkyPNG::Color("green @ 1.0")
          poly[:inner].each do |sequence|
            draw_polygon(sequence, png_image, color, zoom)
          end
        end
      end

      def self.draw_polygon(sequence, png_image, color, zoom, margin = 0)
        return if sequence.empty?
        sequence.each_cons(2) do |coords|
          png_image.draw_line(coords[0][:x] * zoom,
            coords[0][:y] * zoom,
            coords[1][:x] * zoom,
            coords[1][:y] * zoom, color)
        end
        png_image.draw_line(sequence[0][:x] * zoom,
          sequence[0][:y] * zoom,
          sequence[-1][:x] * zoom,
          sequence[-1][:y] * zoom, color)
      end
    end
  end
end
