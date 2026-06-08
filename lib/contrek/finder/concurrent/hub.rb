# frozen_string_literal: true

module Contrek
  module Concurrent
    class Hub
      attr_reader :payloads
      def initialize(height:)
        # @payloads = Array.new(height)
        @payloads = {}
      end
    end
  end
end
