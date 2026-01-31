module Contrek
  module Concurrent
    class Hub
      attr_reader :payloads
      def initialize(height:, start_x:, end_x:)
        # @payloads = Array.new(height)
        @payloads = {}
      end
    end
  end
end
