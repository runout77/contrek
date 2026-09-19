module Contrek
  module Shared
    class OpencvConverter
      CHAIN_DIR = [
        [3, 4, 5],
        [2, -1, 6],
        [1, 0, 7]
      ].freeze

      CORNER_X = [0, 1, 1, 0].freeze
      CORNER_Y = [1, 1, 0, 0].freeze

      def contour_to_cell_boundary(contour, rect)
        raw = []
        n = contour.size

        return raw if n == 0
        if n == 1
          x = contour[0][:x]
          y = contour[0][:y]
          return [
            {x: x, y: y + 1},
            {x: x + 1, y: y + 1},
            {x: x + 1, y: y},
            {x: x, y: y}
          ]
        end

        n.times do |i|
          previous = contour[(i - 1) % n]
          current = contour[i]
          next_p = contour[(i + 1) % n]

          incoming = chain_direction(previous, current)
          outgoing = chain_direction(current, next_p)

          corner = incoming >> 1
          last_corner = ((outgoing + 1) >> 1) & 3

          loop do
            raw << {
              x: current[:x] + CORNER_X[corner],
              y: current[:y] + CORNER_Y[corner]
            }
            break if corner == last_corner
            corner = (corner + 1) & 3
          end
        end

        # build path parts
        edges = []
        raw.size.times do |i|
          a = raw[i]
          b = raw[(i + 1) % raw.size]
          next if a == b

          key = [
            [a[:x], a[:y]],
            [b[:x], b[:y]]
          ].sort
          edges << {a: a, b: b, key: key}
        end

        counts = Hash.new(0)
        edges.each do |edge|
          counts[edge[:key]] += 1
        end

        kept = {}
        edges.select! do |edge|
          key = edge[:key]
          next false if counts[key].even?
          next false if kept[key]

          kept[key] = true
          true
        end
        return [] if edges.empty?

        outgoing = Hash.new { |h, k| h[k] = [] }
        edges.each_with_index do |edge, i|
          outgoing[[edge[:a][:x], edge[:a][:y]]] << i
        end

        used = Array.new(edges.size, false)
        result = []
        current = 0

        loop do
          break if used.all?
          if used[current]
            current = used.index(false)
            break unless current
          end

          edge = edges[current]
          used[current] = true
          result << edge[:a]
          finish = edge[:b]
          candidates = outgoing[[finish[:x], finish[:y]]]
          next_edge = candidates.find { |index| !used[index] }

          if next_edge
            current = next_edge
          else
            current = used.index(false)
            break unless current
          end
        end
        rotate_to_scanline_start(result, rect)
      end

      def rect_to_bounds(rect)
        {min_x: rect[:x],
         max_x: rect[:x] + rect[:width],
         min_y: rect[:y],
         max_y: rect[:y] + rect[:height]}
      end

      private

      def rotate_to_scanline_start(points, rect)
        return points if points.empty?

        min_y = rect[:y]
        min_x = points.select { |p| p[:y] == min_y }.map { |p| p[:x] }.min
        index = points.index { |p| p[:x] == min_x && p[:y] == min_y }
        (index && index > 0) ? points.rotate(index) : points
      end

      def chain_direction(from, to)
        dx = to[:x] - from[:x]
        dy = to[:y] - from[:y]

        raise ArgumentError, "Zero-length contour step" if dx == 0 && dy == 0
        if dx.abs > 1 || dy.abs > 1
          raise ArgumentError, "Non-adjacent contour step"
        end

        CHAIN_DIR[dx + 1][dy + 1]
      end
    end
  end
end
