module Contrek
  module Bitmaps
    class Bitmap
      include Painting

      def scan
        x = 0
        y = 0
        loop do
          yield x, y, value_at(x, y)
          x += 1
          if x == w
            x = 0
            y += 1
            break if y == h
          end
        end
      end
    end
  end
end
