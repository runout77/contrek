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

      def draw_rect(x:, y:, width:, height:, color: "o", filled: true)
        (y...(y + height)).each do |row|
          (x...(x + width)).each do |col|
            if filled || row == y || row == y + height - 1 || col == x || col == x + width - 1
              value_set(col, row, color)
            end
          end
        end
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

      def draw_numbered_polygons(polygons)
        polygons.each do |polygon|
          color = "A"
          polygon[:outer].each_with_index do |position, index|
            value_set(position[:x], position[:y], color)
            color = next_color(color)
          end
          polygon[:inner].each do |sequence|
            color = "a"
            sequence.each_with_index do |position, index|
              value_set(position[:x], position[:y], color)
              color = next_color(color)
            end
          end
        end
      end

      def to_terminal(label = nil)
        puts label if label
        puts "  " + (0...@module).map { |i| (i % 10).to_s }.join
        n = 0
        @raw.scan(/.{1,#{@module}}/).each do |line|
          colored_line = line.chars.map { |c| colorize_char(c) }.join
          puts "#{n} #{colored_line}"
          n += 1
          n = 0 if n >= 10
        end
        puts
      end

      private

      def next_color(color)
        return "A" if color == "Z"
        return "a" if color == "z"
        color.next
      end

      def colorize_char(char)
        case char
        when "A".."Z"
          "\e[91;1m#{char}\e[0m"
        when "a".."z"
          "\e[92;1m#{char}\e[0m"
        else
          char
        end
      end
    end
  end
end
