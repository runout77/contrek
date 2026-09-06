# frozen_string_literal: true

require "ffi"

module Contrek
  module Bitmaps
    class RgbaBitmap < Bitmap
      BYTES_PER_PIXEL = 4

      def initialize(width, height)
        @width = width
        @height = height
        @raw = FFI::MemoryPointer.new(:uint8, @width * @height * BYTES_PER_PIXEL)
      end

      def w
        @width
      end

      def h
        @height
      end

      def get_bytes_per_pixel
        BYTES_PER_PIXEL
      end

      def value_at(x, y)
        rgb_value_at(x, y)
      end

      def get_row_ptr(y)
        @raw + (y * @width * BYTES_PER_PIXEL)
      end

      def rgb_value_at(x, y)
        index = (y * @width + x) * BYTES_PER_PIXEL
        r = @raw.get_uint8(index)
        g = @raw.get_uint8(index + 1)
        b = @raw.get_uint8(index + 2)
        a = @raw.get_uint8(index + 3)
        r | (g << 8) | (b << 16) | (a << 24)
      end

      def read_bytes(size)
        @raw.read_bytes(size)
      end
    end
  end
end
