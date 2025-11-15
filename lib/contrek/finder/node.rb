module Contrek
  module Finder
    class Node
      include Listable

      attr_reader :min_x, :max_x, :y, :name, :tangs, :tangs_sequence, :tangs_count, :data_pointer
      attr_accessor :track, :abs_x_index, :outer_index, :inner_index

      T_UP = -1
      T_DOWN = 1
      OMAX = 1 << 0
      OMIN = 1 << 1
      IMAX = 1 << 2
      IMIN = 1 << 3
      OCOMPLETE = OMIN | OMAX

      TURN_MAX = IMAX | OMAX
      TURN_MIN = IMIN | OMIN

      # 0 = outer
      # 1 = inner
      TURNER = [[OMAX, OMIN], [TURN_MAX, TURN_MIN]]

      OUTER = 0
      INNER = 1

      def initialize(cluster, min_x, max_x, y, name)
        @name = name
        @min_x = min_x
        @max_x = max_x
        @y = y
        @tangs = {T_UP => [], T_DOWN => []}
        @tangs_sequence = nil
        @tangs_count = 0
        @track = 0
        @abs_x_index = 0
        @data_pointer = cluster.lists.get_data_pointer
        @up_indexer = 0
        @down_indexer = 0
        @outer_index = -1
        @inner_index = -1
        cluster.add_node(self)
      end

      def tangs?(node)
        @min_x <= node.max_x && node.min_x <= @max_x
      end

      def my_next(last, versus, mode)
        last_node_index = if last.y < y
          last.abs_x_index + @up_indexer
        else
          @down_indexer - last.abs_x_index
        end

        case mode
        when :outer
          if versus == :o
            (last_node_index == tangs_sequence.size - 1) ? last_node_index = 0 : last_node_index += 1
          else
            (last_node_index == 0) ? last_node_index = tangs_sequence.size - 1 : last_node_index -= 1
          end

        when :inner

          if versus == :o
            (last_node_index == 0) ? last_node_index = tangs_sequence.size - 1 : last_node_index -= 1
          else
            (last_node_index == tangs_sequence.size - 1) ? last_node_index = 0 : last_node_index += 1
          end

        end
        tangs_sequence.at(last_node_index)
      end

      def coords_entering_to(enter_to, enter_mode, tracking)
        enter_to_index = if enter_to.y < y
          enter_to.abs_x_index + @up_indexer
        else
          @down_indexer - enter_to.abs_x_index
        end
        ds = tangs_sequence[enter_to_index]
        coords_source = ds.send(enter_mode)
        enter_to.track |= TURNER[tracking][coords_source[:m] - 1]
        coords_source[:point]
      end

      def tangs_with_x?(x)
        x.between?(@min_x, @max_x)
      end

      def track_uncomplete
        (@track & OCOMPLETE) != OCOMPLETE
      end

      def track_complete
        (@track & OCOMPLETE) == OCOMPLETE
      end

      def add_intersection(other_node)
        if other_node.y < y
          @tangs[T_UP] << other_node
        else
          @tangs[T_DOWN] << other_node
        end
      end

      def precalc_tangs_sequences
        @tangs_sequence = Array.new(tangs[T_UP].size + tangs[T_DOWN].size)
        tangs = self.tangs[T_UP].sort_by(&:min_x)
        n = -1
        @up_indexer = -tangs[0].abs_x_index if tangs.size > 0
        tangs.each do |t_node|
          nd = Contrek::Finder::PolygonFinder::NodeDescriptor.new(t_node, {point: {x: t_node.max_x, y: t_node.y}, m: OMAX}, {point: {x: t_node.min_x, y: t_node.y}, m: OMIN})
          tangs_sequence[n += 1] = nd
        end
        tangs = self.tangs[T_DOWN].sort_by(&:min_x).reverse
        @down_indexer = (tangs.last.abs_x_index + self.tangs[T_DOWN].size + self.tangs[T_UP].size - 1) if tangs.size > 0
        tangs.each do |t_node|
          nd = Contrek::Finder::PolygonFinder::NodeDescriptor.new(t_node, {point: {x: t_node.min_x, y: t_node.y}, m: OMIN}, {point: {x: t_node.max_x, y: t_node.y}, m: OMAX})
          tangs_sequence[n += 1] = nd
        end
        @tangs_count = tangs_sequence.size
      end
    end
  end
end
