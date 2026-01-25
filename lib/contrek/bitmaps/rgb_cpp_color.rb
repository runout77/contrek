module Contrek
  module Bitmaps
    class RgbCppColor
      attr_reader :raw
      def initialize(r:, g:, b:, a: 255)
        @raw = (a << 24) | (b << 16) | (g << 8) | r
      end
    end
  end
end
