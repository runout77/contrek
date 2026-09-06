# frozen_string_literal: true

require "ffi"

module Contrek
  module Bitmaps
    module Streaming
      class RasterStreamer
        OVERLAP = 1

        attr_reader :stripe_height

        def initialize(source, stripe_height:)
          @source = source
          @stripe_height = stripe_height

          raise ArgumentError, "stripe_height must be greater than 1" if @stripe_height <= OVERLAP
        end

        def each(buffer)
          return enum_for(:each, buffer) unless block_given?

          width = @source.width
          height = @source.height
          bytes_per_pixel = @source.get_bytes_per_pixel

          row_size = width * bytes_per_pixel

          source_row = 0
          buffer_rows = 0
          first_stripe = true

          while source_row < height
            unless first_stripe
              previous_last_row = buffer.get_row_ptr(buffer_rows - 1)
              current_first_row = buffer.get_row_ptr(0)
              current_first_row.put_bytes(0, previous_last_row.read_bytes(row_size))
            end

            overlap_rows = first_stripe ? 0 : OVERLAP
            available_rows = @stripe_height - overlap_rows
            remaining_rows = height - source_row
            rows_to_read = [available_rows, remaining_rows].min

            rows_read = 0
            rows_to_read.times do |i|
              buffer_y = overlap_rows + i
              row_ptr = buffer.get_row_ptr(buffer_y)
              break unless @source.read_next_row(row_ptr, row_size)

              source_row += 1
              rows_read += 1
            end

            buffer_rows = overlap_rows + rows_read
            break if buffer_rows == 0

            yield buffer, buffer_rows, buffer_rows * row_size

            first_stripe = false
          end
        end
      end
    end
  end
end
