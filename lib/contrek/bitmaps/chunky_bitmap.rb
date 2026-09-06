# frozen_string_literal: true

require "ffi"

module Contrek
  module Bitmaps
    class ChunkyBitmap < Bitmap
      def initialize(data, mod)
        @module = mod
        @height = data.bytesize / @module
        @raw = FFI::MemoryPointer.new(:uint8, data.bytesize)
        @raw.put_bytes(0, data)
      end

      def clear(val = "0")
        @raw.put_bytes(0, val * @module * h)
      end

      def w
        @module
      end

      def h
        @height
      end

      def get_bytes_per_pixel
        1
      end

      def get_row_ptr(y)
        @raw + (@module * y)
      end

      def value_at(x, y)
        @raw.get_uint8(y * @module + x).chr
      end

      def value_set(x, y, value)
        return if y >= h
        return if x >= w

        @raw.put_uint8(y * @module + x, value.ord)
      end

      def dup!
        ChunkyBitmap.new(@raw.read_bytes(@module * h), @module)
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
        @raw.read_bytes(@module * h).scan(/.{1,#{@module}}/).each do |line|
          colored_line = line.chars.map { |c| colorize_char(c) }.join
          puts "#{n} #{colored_line}"
          n += 1
          n = 0 if n >= 10
        end
        puts
      end

      def transpose!
        transposed = ""
        w.times do |x|
          h.times do |y|
            transposed += value_at(x, y)
          end
        end
        old_width = w
        @module = h
        @height = old_width
        @raw = FFI::MemoryPointer.new(:uint8, transposed.bytesize)
        @raw.put_bytes(0, transposed)
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
