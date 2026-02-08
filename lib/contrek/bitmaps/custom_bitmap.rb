module Contrek
  module Bitmaps
    class CustomBitmap < PngBitmap
      def initialize(w:, h:, color: ChunkyPNG::Color::TRANSPARENT)
        @image = ChunkyPNG::Image.new(w, h, color)
      end
    end
  end
end
