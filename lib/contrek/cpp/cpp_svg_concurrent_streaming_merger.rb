# frozen_string_literal: true

module Contrek
  module Cpp
    class CPPSvgConcurrentStreamingMerger < CPPSvgStreamingMerger
      def self.new(stream_to:, total_width:, total_height:, number_of_threads: 0, options: nil)
        super(number_of_threads, options, stream_to, total_width, total_height)
      end
    end
  end
end
