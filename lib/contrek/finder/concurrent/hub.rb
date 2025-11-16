module Contrek
  module Concurrent
    class Hub
      attr_reader :payloads, :width
      def initialize(height:, width:)
        @width = width
        # @payloads = Array.new(width * height)
        @payloads = {}
      end
    end
  end
end
