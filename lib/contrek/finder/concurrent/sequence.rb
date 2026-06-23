# frozen_string_literal: true

module Contrek
  module Concurrent
    class Sequence
      attr_accessor :shape
      prepend Queueable

      def is_not_vertical
        return false if size < 2
        x0 = head.payload[:x]
        rewind!
        while (position = iterator)
          return true if position.payload[:x] != x0
          forward!
        end
        false
      end

      def get_vector_cache
        @vector_cache ||= to_a
      end
    end
  end
end
