# frozen_string_literal: true

module Contrek
  module Finder
    class NodeCluster
      attr_reader :root_nodes, :sequences, :polygons, :lists, :treemap, :vert_nodes, :options
      VERSUS_INVERTER = {a: :o, o: :a}

      def initialize(h, options)
        @options = options
        @vert_nodes = Array.new(h) { [] }
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
          Contrek::Reducers::RasterReducer.new(points: seq, options: @options).reduce! if @options[:compress].has_key?(:raster)
          Contrek::Reducers::VisvalingamReducer.new(points: seq, options: @options[:compress][:visvalingam]).reduce! if @options[:compress].has_key?(:visvalingam)
          Contrek::Reducers::DouglasPeuckerReducer.new(points: seq).reduce! if @options[:compress].has_key?(:douglas_peucker)
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

          if next_node
            beginning_point = (versus == :a) ? root_node.nw_point : root_node.ne_point
            @sequence_coords << beginning_point
            bounds.expand(**beginning_point)

            coord = next_node.coords_entering_to(root_node, VERSUS_INVERTER[versus], Contrek::Finder::Node::OUTER)
            @sequence_coords << coord
            bounds.expand(**coord)
          end

          plot_node(next_node, root_node, bounds, versus) if @nodes > 0 && !next_node.nil?

          if next_node.nil?
            if versus == :a
              nw_point = root_node.nw_point
              @sequence_coords << nw_point
              bounds.expand(**nw_point)
              @sequence_coords << root_node.sw_point
              se_point = root_node.se_point
              @sequence_coords << se_point
              bounds.expand(**se_point)
              @sequence_coords << root_node.ne_point
            else
              ne_point = root_node.ne_point
              @sequence_coords << ne_point
              bounds.expand(**ne_point)
              @sequence_coords << root_node.se_point
              sw_point = root_node.sw_point
              @sequence_coords << sw_point
              bounds.expand(**sw_point)
              @sequence_coords << root_node.nw_point
            end
          end

          draw_sequence(bitmap, "X") unless bitmap.nil?

          if @sequence_coords.any?
            @polygons << {outer: @sequence_coords, inner: [], bounds: (bounds.to_h if @options[:bounds])}.compact
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
                last_node = plot_inner_node(next_node, inner_v, first, root_node)
                last_coord = last_node.coords_entering_to(first, VERSUS_INVERTER[inner_v], Contrek::Finder::Node::INNER)
                @sequence_coords << last_coord if @sequence_coords.last != last_coord
              end

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
                    return [cindex, (prev.inner_right_index == -1) ? prev.inner_left_index : prev.inner_right_index]
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
                    return [cindex, (prev.inner_left_index == -1) ? prev.inner_right_index : prev.inner_left_index]
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
        @root_nodes.delete(node)
        @inner_plot.delete(node)
        last_node = @plot_sequence.last
        next_node = node.my_next(last_node, versus, :inner)
        @plot_sequence << node

        first_is_max = ((node.y > last_node.y) == (versus == :a))
        if first_is_max
          node.inner_right_index = stop_at.inner_index if node.inner_right_index == -1
        elsif node.inner_left_index == -1
          node.inner_left_index = stop_at.inner_index
        end

        plot = true
        if next_node.y == last_node.y
          virtual_index = node.tangs_sequence.send((versus == :a) ? :first : :last)
          plot = (node.get_tangent_node_by_virtual_index(virtual_index) == next_node)
        end

        if plot
          first_point = last_node.coords_entering_to(node, VERSUS_INVERTER[versus], Contrek::Finder::Node::INNER)
          @sequence_coords << first_point if @sequence_coords.last != first_point
          if next_node.y == last_node.y
            if next_node.y < node.y
              pt_a, pt_b = node.sw_point, node.se_point
            else
              pt_a, pt_b = node.ne_point, node.nw_point
            end
            if versus == :o
              @sequence_coords << pt_a
              @sequence_coords << pt_b
            else
              @sequence_coords << pt_b
              @sequence_coords << pt_a
            end
          end
          @sequence_coords << next_node.coords_entering_to(node, versus, Contrek::Finder::Node::INNER)
        end

        if node.track_uncomplete
          @inner_new << node
        else
          @inner_new.delete(node)
        end

        return node if next_node == stop_at
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

        if plot
          start_coord = last_node.coords_entering_to(node, versus, Contrek::Finder::Node::OUTER)
          if @sequence_coords.last != start_coord
            @sequence_coords << start_coord
            bounds.expand(**start_coord)
          end

          final_step = node == start_node && node.track_complete
          if next_node.y == last_node.y
            if next_node.y < node.y
              pt_a, pt_b = node.se_point, node.sw_point
            else
              pt_a, pt_b = node.nw_point, node.ne_point
            end
            first = (versus == :o) ? pt_a : pt_b
            second = (versus == :o) ? pt_b : pt_a
            @sequence_coords << first
            bounds.expand(**first)
            unless final_step
              @sequence_coords << second
              bounds.expand(**second)
            end
          end

          unless final_step
            end_coord = next_node.coords_entering_to(node, VERSUS_INVERTER[versus], Contrek::Finder::Node::OUTER)
            @sequence_coords << end_coord
            bounds.expand(**end_coord)
          end

          if node != start_node
            @inner_plot.contains(node) ? @inner_plot.delete(node) : @inner_plot << node
            if last_node.y == next_node.y
              @inner_plot.contains(node) ? @inner_plot.delete(node) : @inner_plot << node
            end
          end
        end
        # exit if root_node
        return if node == start_node && node.track_complete

        plot_node(next_node, start_node, bounds, versus)
      end

      def add_node(node, offset)
        @nodes += 1
        node.abs_x_index = @vert_nodes[node.y].size

        @vert_nodes[node.y] << node
        @root_nodes << node

        if node.y > 0
          # all nodes until up_node.max_x >= node.min_x
          up_nodes = @vert_nodes[node.y - 1]
          up_nodes_count = up_nodes.size
          if up_nodes_count > 0
            index = 0
            loop do
              up_node = up_nodes[index]
              if ((up_node.max_x - 1) + offset) >= node.min_x
                if (up_node.min_x - offset) <= (node.max_x - 1)
                  node.add_intersection(up_node, index)
                  up_node.add_intersection(node, node.abs_x_index)
                end
                return if (index += 1) == up_nodes_count
                loop do
                  up_node = up_nodes[index]
                  if (up_node.min_x - offset) <= (node.max_x - 1)
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
