module Contrek
  module Bitmaps
    class ChunkyBitmap < Bitmap
      def initialize(data, mod)
        @raw = data.dup
        @module = mod
      end

      def clear(val = "0")
        @raw = val * @module * h
      end

      def w
        @module
      end

      def h
        @raw.size / @module
      end

      def value_at(x, y)
        @raw[y * @module + x]
      end

      def value_set(x, y, value)
        return if y >= h
        return if x >= w

        @raw[y * @module + x] = value
      end
    end
  end
end
