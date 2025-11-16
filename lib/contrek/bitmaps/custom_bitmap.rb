module Contrek
  module Bitmaps
    class CustomBitmap < PngBitmap
      def initialize(w:, h:)
        @image = ChunkyPNG::Image.new(w, h, ChunkyPNG::Color::TRANSPARENT)
      end
    end
  end
end
