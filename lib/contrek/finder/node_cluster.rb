module Contrek
  module Finder
    class NodeCluster
      attr_reader :root_nodes, :sequences, :polygons, :lists, :treemap, :vert_nodes, :options
      VERSUS_INVERTER = {a: :o, o: :a}

      def initialize(h, options)
        @options = options
        @vert_nodes = Array.new(h) { [] }      # per y immetto i nodi
        @sequences = []
        @polygons = []
        @treemap = []
        @nodes = 0
        @lists = Contrek::Finder::Lists.new
        @root_nodes = @lists.add_list
        @inner_plot = @lists.add_list
        @inner_new = @lists.add_list
      end

      def path_sequences
        @polygons.compact.each do |polygon|
          yield polygon[:outer]
          polygon[:inner].each do |sequence|
            yield sequence
          end
        end
      end

      def compress_coords
        path_sequences do |seq|
          Contrek::Reducers::UniqReducer.new(points: seq).reduce! if @options[:compress].has_key?(:uniq)
          Contrek::Reducers::LinearReducer.new(points: seq, options: @options[:compress][:linear]).reduce! if @options[:compress].has_key?(:linear)
          Contrek::Reducers::VisvalingamReducer.new(points: seq, options: @options[:compress][:visvalingam]).reduce! if @options[:compress].has_key?(:visvalingam)
        end
      end

      # nominal sequence
      def named_sequence
        @plot_sequence.map(&:name).join
      end

      # builds node sequences (with space coordinates) array scanning upper and lower element
      # needs root_nodes ready
      def build_tangs_sequence
        @vert_nodes.each do |line|
          line.each do |node|
            node.precalc_tangs_sequences(cluster: self)
          end
        end
      end

      def plot(bitmap)
        versus = @options[:versus]
        inner_v = VERSUS_INVERTER[versus]
        index_order = 0
        while @root_nodes.size > 0
          root_node = @root_nodes.shift

          root_node.outer_index = index_order
          @plot_sequence = []
          @sequence_coords = []
          bounds = Bounds.empty
          # external polygon
          @plot_sequence << root_node

          next_node = if versus == :a
            root_node.get_tangent_node_by_virtual_index(root_node.tangs_sequence.last)
          else
            root_node.get_tangent_node_by_virtual_index(root_node.tangs_sequence.first)
          end
          if !next_node.nil?
            coord = next_node.coords_entering_to(root_node, VERSUS_INVERTER[versus], Contrek::Finder::Node::OUTER)
            @sequence_coords << coord
            bounds.expand(x: coord[:x], y: coord[:y])
          end
          plot_node(next_node, root_node, bounds, versus) if @nodes > 0 && !next_node.nil?

          draw_sequence(bitmap, "X") unless bitmap.nil?
          @polygons << {outer: @sequence_coords, inner: [], bounds: (bounds.to_h if @options[:bounds])}.compact if @sequence_coords.size >= 2
          @sequences << @plot_sequence

          @count = 0
          index_inner = 0
          while @inner_plot.size > 0
            @plot_sequence = []
            @sequence_coords = []
            # mia test
            first = @inner_plot.find { |x| x.tangs_count <= 2 } || @inner_plot.first

            @plot_sequence << first
            @inner_plot.delete(first)
            @root_nodes.delete(first)

            first.inner_index = index_inner

            # @count += 1
            # if @count > 10000
            #  puts "Houston, we have a problem!"
            #  break
            # end

            next_node = if (first.track & Contrek::Finder::Node::OMAX) != 0
              if inner_v == :a
                vert_nodes[first.y + Node::T_UP][first.upper_start]
              else
                vert_nodes[first.y + Node::T_DOWN][first.lower_start]
              end
            elsif inner_v == :a
              vert_nodes[first.y + Node::T_DOWN][first.lower_end]
            else
              vert_nodes[first.y + Node::T_UP][first.upper_end]
            end

            if !next_node.nil?
              @sequence_coords << next_node.coords_entering_to(first, inner_v, Contrek::Finder::Node::INNER)
            end

            plot_inner_node(next_node, inner_v, first, root_node) if !next_node.nil?

            draw_sequence(bitmap, "+") unless bitmap.nil?

            @polygons.last[:inner] << @sequence_coords

            @inner_plot.grab(@inner_new)
            index_inner += 1
          end
          # tree
          @treemap << ((versus == :a) ? test_in_hole_a(root_node) : test_in_hole_o(root_node)) if @options.has_key?(:treemap)
          index_order += 1
        end
      end

      def test_in_hole_a(node)
        if node.outer_index > 0
          start_left = node.abs_x_index - 1
          loop do
            prev = @vert_nodes[node.y][start_left]
            if ((cindex = prev.outer_index) < node.outer_index) && ((prev.track & Contrek::Finder::Node::IMAX) != 0)
              start_right = node.abs_x_index
              while (start_right += 1) != @vert_nodes[node.y].size
                tnext = @vert_nodes[node.y][start_right]
                if tnext.outer_index == cindex
                  if (tnext.track & Contrek::Finder::Node::IMIN) != 0
                    return [cindex, prev.inner_index]
                  else
                    return [-1, -1]
                  end
                end
              end
            end
            break if (start_left -= 1) < 0
          end
        end
        [-1, -1]
      end

      def test_in_hole_o(node)
        if node.outer_index > 0 && @vert_nodes[node.y].last != node
          start_left = node.abs_x_index + 1
          loop do
            prev = @vert_nodes[node.y][start_left]
            if ((cindex = prev.outer_index) < node.outer_index) && ((prev.track & Contrek::Finder::Node::IMIN) != 0)
              start_right = node.abs_x_index
              while (start_right -= 1) >= 0
                tnext = @vert_nodes[node.y][start_right]
                if tnext.outer_index == cindex
                  if (tnext.track & Contrek::Finder::Node::IMAX) != 0
                    return [cindex, prev.inner_index]
                  else
                    return [-1, -1]
                  end
                end
              end
            end
            break if (start_left += 1) == @vert_nodes[node.y].size
          end
        end
        [-1, -1]
      end

      def draw_sequence(bitmap, val = nil)
        count = 1
        @sequence_coords.each do |coords|
          bitmap.value_set(coords[:x], coords[:y], val.nil? ? count.alph : val)
          count += 1
        end
      end

      # inner way
      # nodes in @plot_sequence
      # coordinates in @sequence_coords
      def plot_inner_node(node, versus, stop_at, start_node)
        node.outer_index = start_node.outer_index
        node.inner_index = stop_at.inner_index
        @root_nodes.delete(node)
        @inner_plot.delete(node)
        last_node = @plot_sequence.last
        next_node = node.my_next(last_node, versus, :inner)
        @plot_sequence << node

        plot = true
        if next_node.y == last_node.y
          virtual_index = node.tangs_sequence.send((versus == :a) ? :first : :last)
          plot = (node.get_tangent_node_by_virtual_index(virtual_index) == next_node)
        end
        if plot
          @sequence_coords << last_node.coords_entering_to(node, VERSUS_INVERTER[versus], Contrek::Finder::Node::INNER)
          if node != start_node
            if last_node.y == next_node.y
              @sequence_coords << next_node.coords_entering_to(node, versus, Contrek::Finder::Node::INNER)
            end
          end
        end

        if node.track_uncomplete
          @inner_new << node
        else
          @inner_new.delete(node)
        end

        return if next_node == stop_at
        plot_inner_node(next_node, versus, stop_at, start_node)
      end

      # contour tracing core logic loop
      def plot_node(node, start_node, bounds, versus = :a)
        @root_nodes.delete(node)

        node.outer_index = start_node.outer_index
        last_node = @plot_sequence.last
        next_node = node.my_next(last_node, versus, :outer)

        @plot_sequence << node

        plot = true
        if next_node.y == last_node.y
          virtual_index = node.tangs_sequence.send((versus == :a) ? :last : :first)
          plot = (node.get_tangent_node_by_virtual_index(virtual_index) == next_node)
        end

        # coord
        if plot
          c = last_node.coords_entering_to(node, versus, Contrek::Finder::Node::OUTER)
          @sequence_coords << c
          bounds.expand(x: c[:x], y: c[:y])
          if node != start_node
            @inner_plot.contains(node) ? @inner_plot.delete(node) : @inner_plot << node
            if last_node.y == next_node.y
              c = next_node.coords_entering_to(node, VERSUS_INVERTER[versus], Contrek::Finder::Node::OUTER)
              @sequence_coords << c
              bounds.expand(x: c[:x], y: c[:y])
              @inner_plot.contains(node) ? @inner_plot.delete(node) : @inner_plot << node
            end
          end
        end
        # exit if root_node

        if node == start_node
          return if node.track_complete
        end
        plot_node(next_node, start_node, bounds, versus)
      end

      def add_node(node, offset)
        @nodes += 1
        node.abs_x_index = @vert_nodes[node.y].size

        @vert_nodes[node.y] << node
        @root_nodes << node

        if node.y > 0
          # all nodes untle up_node.max_x >= node.min_x
          up_nodes = @vert_nodes[node.y - 1]
          up_nodes_count = up_nodes.size
          if up_nodes_count > 0
            index = 0
            loop do
              up_node = up_nodes[index]
              if (up_node.max_x + offset) >= node.min_x
                if (up_node.min_x - offset) <= node.max_x
                  node.add_intersection(up_node, index)
                  up_node.add_intersection(node, node.abs_x_index)
                end
                return if (index += 1) == up_nodes_count
                loop do
                  up_node = up_nodes[index]
                  if (up_node.min_x - offset) <= node.max_x
                    node.add_intersection(up_node, index)
                    up_node.add_intersection(node, node.abs_x_index)
                  else
                    return
                  end
                  break if (index += 1) == up_nodes_count
                end
                return
              end
              break if (index += 1) == up_nodes_count
            end
          end

        end
      end
    end
  end
end
