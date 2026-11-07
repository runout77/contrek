# frozen_string_literal: true

module Contrek
  module Cpp
    class CPPGeoJsonConcurrentStreamingMerger < CPPGeoJsonStreamingMerger
      def self.new(stream_to:, number_of_threads: 0, options: nil)
        super(number_of_threads, options, stream_to)
      end
    end
  end
end
