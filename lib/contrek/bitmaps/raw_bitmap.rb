module Contrek
  module Bitmaps
    class RawBitmap < PngBitmap
      def initialize(w:, h:, color: ChunkyPNG::Color::TRANSPARENT)
        @image = ChunkyPNG::Image.new(w, h, color)
      end
    end
  end
end
