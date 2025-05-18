module Contrek
  module Reducers
    class Reducer
      def initialize(points: list_of_points, options: {})
        @points = points
        @opts = options
      end

      def reduce!
        @points
      end
    end
  end
end
