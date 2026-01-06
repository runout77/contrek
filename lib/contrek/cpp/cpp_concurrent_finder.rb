module Contrek
  module Cpp
    class CPPConcurrentFinder < CPPFinder
      def initialize(bitmap:, matcher:, number_of_threads: 0, options: nil)
        super(number_of_threads, bitmap, matcher, options)
      end
    end
  end
end
