module Contrek
  module Concurrent
    class HorizontalMerger < Merger
      def add_tile(result)
        translate(result, @current_x)
        super
      end
    end
  end
end
