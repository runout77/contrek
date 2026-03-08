module Contrek
  module Cpp
    class CPPConcurrentVerticalMerger < CPPVerticalMerger
      def initialize(number_of_threads: 0, options: nil)
        super(number_of_threads, options)
      end
    end
  end
end
