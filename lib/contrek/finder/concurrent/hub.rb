module Contrek
  module Concurrent
    class Hub
      attr_reader :payloads, :width
      def initialize(start_x:, end_x:)
        @width = end_x - start_x
        # @payloads = Array.new(width * height)
        @payloads = {}
      end
    end
  end
end
