module Contrek
  module Reducers
    class UniqReducer < Reducer
      def reduce!
        @points.replace @points.reject.with_index { |e, i| i < (@points.size - 1) and e[:x] == @points[i + 1][:x] && e[:y] == @points[i + 1][:y] }
      end
    end
  end
end
