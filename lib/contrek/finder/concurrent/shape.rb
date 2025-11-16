module Contrek
  module Concurrent
    class Shape
      attr_accessor :outer_polyline, :inner_polylines

      def clear_inner!
        @inner_polylines = []
      end
    end
  end
end
