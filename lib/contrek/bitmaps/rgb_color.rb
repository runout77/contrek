# frozen_string_literal: true

module Contrek
  module Bitmaps
    class RgbColor
      attr_reader :raw
      def initialize(r:, g:, b:, a: 255)
        @raw = (r << 24) + (g << 16) + (b << 8) + a
      end
    end
  end
end
