# frozen_string_literal: true

module Contrek
  module Bitmaps
    module Rendering
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def to_window(result, zoom: 100, coords: true, window_w: 2000, window_h: 1200, font_h: 20)
          require "ruby2d"
          ubuntu_purple = ChunkyPNG::Color.from_hex("#77216F")
          bm = RawBitmap.new(w: window_w, h: window_h, color: ubuntu_purple)
          # grid
          light_purple = ChunkyPNG::Color.from_hex("#95338B")
          (window_w / zoom).times { |x| bm.draw_line(x * zoom, 0, x * zoom, window_h, light_purple) }
          (window_h / zoom).times { |y| bm.draw_line(0, y * zoom, window_w, y * zoom, light_purple) }
          # polygons
          Painting.direct_draw_polygons(result.points, bm, zoom: zoom)
          # windowing
          Tempfile.create do |temp_file|
            bm.image.save(temp_file.path, color_mode: ChunkyPNG::COLOR_TRUECOLOR_ALPHA)
            Window.clear
            Window.set(
              title: "Rendering #{result[:metadata][:groups]} polygons",
              width: window_w,
              height: window_h,
              resizable: true
            )
            Image.new(
              temp_file.path,
              x: 0, y: 0,
              width: window_w,
              height: window_h
            )
            draw_labels(result.points, zoom: zoom, draw_coords: coords, font_h:)
            Window.on :key_down do |event|
              if event.key == "escape"
                Window.close
              end
              if event.key == "s"
                Window.screenshot("window_content.png")
              end
            end
            Window.show
          end
        end

        private

        def draw_labels(polygons, font_h:, zoom: 1.0, draw_coords: true)
          positions = []
          polygons.compact.each do |poly|
            ([poly[:outer]] + poly[:inner]).each do |seq|
              seq.each_with_index do |coords, n|
                x = coords[:x] * zoom
                y = coords[:y] * zoom
                y += font_h + 2 if positions.index([x, y])
                t = (n + 1).to_s
                t += " - [#{coords[:x]},#{coords[:y]}]" if draw_coords
                draw_text(x, y, t, font_h) unless draw_coords.nil?
                positions << [x, y]
              end
            end
          end
        end

        def draw_text(x, y, text, font_h)
          Text.new(text, x:, y:, size: font_h, color: "white", z: 10)
        end
      end
    end
  end
end
