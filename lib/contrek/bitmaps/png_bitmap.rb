require "chunky_png"

module Contrek
  module Bitmaps
    class PngBitmap < Bitmap
      def initialize(file_path)
        @image = ChunkyPNG::Image.from_file(file_path)
      end

      def w
        @image.dimension.width
      end

      def h
        @image.dimension.height
      end

      def draw_line(start_x, start_y, end_x, end_y, value)
        @image.line_xiaolin_wu(start_x, start_y, end_x, end_y, value)
      end

      def value_at(x, y)
        @image[x, y]
      end

      def rgb_value_at(x, y)
        value_at(x, y)
      end

      def hsv_at(x, y)
        @image.get_pixel(x, y).to_hsv
      end

      def value_set(x, y, value)
        @image[x, y] = value
      end

      def save(filename)
        @image.save(filename, interlace: true, compression: Zlib::NO_COMPRESSION)
      end

      def to_tmp_file
        tmp_png_file = Tempfile.new
        tmp_png_file.binmode
        tmp_png_file.write(@image.to_blob)
        tmp_png_file
      end

      def resize_h(new_h)
        old_w = w
        old_h = h

        new_w = (old_w * new_h) / old_h
        @image = @image.resize(new_w, new_h)
      end

      def inspect
        "PngBitMap"
      end

      def clear
        @image = ChunkyPNG::Image.new(w, h, ChunkyPNG::Color.rgba(255, 255, 255, 255))
      end
    end
  end
end
