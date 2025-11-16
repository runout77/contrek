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

      def dup!
        ChunkyBitmap.new(@raw, @module)
      end

      def draw_polygons(polygons)
        polygons.each do |polygon|
          [[:outer, "o"], [:inner, "i"]].each do |side, color|
            sequences = polygon[side]
            sequences = [sequences] if side == :outer
            sequences.each do |sequence|
              sequence.each do |position|
                value_set(position[:x], position[:y], color)
              end
            end
          end
        end
      end

      def to_terminal
        puts "  " + (0...@module).map { |i| (i % 10).to_s }.join
        n = 0
        @raw.scan(/.{1,#{@module}}/).each do |line|
          puts n.to_s + " " + line
          n += 1
          n = 0 if n >= 10
        end
        puts
      end
    end
  end
end
