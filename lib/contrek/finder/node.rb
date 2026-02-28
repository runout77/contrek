module Contrek
  module Finder
    class Node
      include Listable

      attr_reader :min_x, :max_x, :y, :name, :tangs_sequence, :tangs_count, :data_pointer,
        :upper_start, :upper_end, :lower_start, :lower_end, :start_point, :end_point
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

      def initialize(cluster, min_x, max_x, y, name, connectivity_offset = 0)
        @name = name
        @min_x = min_x
        @max_x = max_x
        @y = y
        @tangs_sequence = nil
        @tangs_count = 0
        @track = 0
        @abs_x_index = 0
        @data_pointer = cluster.lists.get_data_pointer
        @up_indexer = 0
        @down_indexer = 0
        @outer_index = -1
        @inner_index = -1
        @upper_start = Float::INFINITY
        @upper_end = -1
        @lower_start = Float::INFINITY
        @lower_end = -1
        @start_point = {x: min_x, y: y}
        @end_point = {x: max_x, y: y}
        @cluster = cluster
        cluster.add_node(self, connectivity_offset)
      end

      def get_tangent_node_by_virtual_index(virtual_index)
        return nil if virtual_index.nil?
        if virtual_index < 0
          @cluster.vert_nodes[y + T_UP][-(virtual_index + 1)]
        else
          @cluster.vert_nodes[y + T_DOWN][virtual_index]
        end
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
        get_tangent_node_by_virtual_index(@tangs_sequence.at(last_node_index))
      end

      def coords_entering_to(enter_to, enter_mode, tracking)
        enter_to_index = if enter_to.y < y
          enter_to.abs_x_index + @up_indexer
        else
          @down_indexer - enter_to.abs_x_index
        end

        tg_index = @tangs_sequence[enter_to_index]
        if tg_index < 0
          node_up = @cluster.vert_nodes[y + T_UP][-(tg_index + 1)]
          if enter_mode == :a
            enter_to.track |= TURNER[tracking][OMAX - 1]
            point = node_up.end_point
          else
            enter_to.track |= TURNER[tracking][OMIN - 1]
            point = node_up.start_point
          end
        else
          node_down = @cluster.vert_nodes[y + T_DOWN][tg_index]
          if enter_mode == :a
            enter_to.track |= TURNER[tracking][OMIN - 1]
            point = node_down.start_point
          else
            enter_to.track |= TURNER[tracking][OMAX - 1]
            point = node_down.end_point
          end
        end
        point
      end

      def track_uncomplete
        (@track & OCOMPLETE) != OCOMPLETE
      end

      def track_complete
        (@track & OCOMPLETE) == OCOMPLETE
      end

      def add_intersection(other_node, other_node_index)
        if other_node.y < y
          @upper_start = other_node_index if other_node_index < @upper_start
          @upper_end = other_node_index if other_node_index > @upper_end
        else
          @lower_start = other_node_index if other_node_index < @lower_start
          @lower_end = other_node_index if other_node_index > @lower_end
        end
      end

      def precalc_tangs_sequences(cluster:)
        @tangs_sequence = []
        @up_indexer = -cluster.vert_nodes[@y + T_UP][@upper_start].abs_x_index if @upper_end >= 0
        if @upper_end >= 0
          (@upper_start..@upper_end).each do |upper_pos|
            @tangs_sequence << -(upper_pos + 1)
          end
        end
        if @lower_end >= 0
          lower_size = (@lower_end >= 0) ? (@lower_end - @lower_start + 1) : 0
          upper_size = (@upper_end >= 0) ? (@upper_end - @upper_start + 1) : 0
          @down_indexer = (cluster.vert_nodes[@y + T_DOWN][@lower_start].abs_x_index + lower_size + upper_size - 1)
        end
        if @lower_end >= 0
          @lower_end.downto(@lower_start).each do |lower_pos|
            @tangs_sequence << lower_pos
          end
        end
        @tangs_count = tangs_sequence.size
      end
    end
  end
end
