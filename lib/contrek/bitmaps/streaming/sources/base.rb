# frozen_string_literal: true

module Contrek
  module Bitmaps
    module Streaming
      module Sources
        class Base
          def width
            raise NotImplementedError
          end

          def height
            raise NotImplementedError
          end

          def get_bytes_per_pixel
            raise NotImplementedError
          end

          def read_next_row(destination, row_size)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
