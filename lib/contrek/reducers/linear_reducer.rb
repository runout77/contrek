module Contrek
  module Reducers
    class LinearReducer < Reducer
      def reduce!
        start_p = @points[0]
        end_p = @points[1]
        dir = seq_dir(start_p, end_p)
        @points[2..].map.with_index do |point, i|
          if (act_seq = seq_dir(end_p, point)) == dir
            @points.delete_at(@points.index(end_p))
          else
            dir = act_seq
          end
          end_p = point
        end
      end

      private

      def seq_dir(a, b)
        [b[:x] - a[:x], b[:y] - a[:y]]
      end
    end
  end
end
