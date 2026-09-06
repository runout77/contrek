# frozen_string_literal: true

require "forwardable"

module Contrek
  module Bitmaps
    module Streaming
      module Sources
        class Ascii < Base
          extend Forwardable

          def_delegator :@bitmap, :w, :width
          def_delegator :@bitmap, :h, :height
          def_delegators :@bitmap, :get_bytes_per_pixel

          def initialize(bitmap)
            @current_row = 0
            @bitmap = bitmap
          end

          def read_next_row(destination, row_size)
            return false if @current_row >= height

            row = @bitmap.get_row_ptr(@current_row)
            destination.put_bytes(0, row.read_bytes(row_size))
            @current_row += 1
            true
          end
        end
      end
    end
  end
end
