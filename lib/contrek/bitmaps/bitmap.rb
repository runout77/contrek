module Contrek
  module Bitmaps
    class Bitmap
      include Painting

      def scan(start_x: 0, end_x: w)
        x = start_x
        y = 0
        loop do
          yield x, y, value_at(x, y)
          x += 1
          if x == end_x
            x = start_x
            y += 1
            break if y == h
          end
        end
      end

      def copy_rect(src_bitmap:, src_x:, src_y:, dest_x:, dest_y:, rect_w:, rect_h:)
        rect_h.times do |hp|
          rect_w.times do |wp|
            src_pos_x = src_x + wp
            src_pos_y = src_y + hp
            src_color = src_bitmap.value_at(src_pos_x, src_pos_y)
            dest_pos_x = dest_x + wp
            dest_pos_y = dest_y + hp
            value_set(dest_pos_x, dest_pos_y, src_color)
          end
        end
      end

      def clear!(color: " ")
        w.times do |x|
          h.times do |y|
            value_set(x, y, color)
          end
        end
      end
    end
  end
end
