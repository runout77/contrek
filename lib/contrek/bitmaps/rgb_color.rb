module Contrek
  module Bitmaps
    class RgbColor
      attr_reader :raw
      def initialize(r:, g:, b:, a: 255)
        @r = r
        @g = g
        @b = b
        @a = a
        @raw = (r << 24) + (g << 16) + (b << 8) + a
      end

      def to_rgb_raw
        @raw >> 8
      end

      def self.reverse_raw(raw)
        [:a, :b, :g, :r].each_with_object({}) do |c, h|
          h[c] = raw & 0xFF
          raw >>= 8
        end
      end
    end
  end
end
