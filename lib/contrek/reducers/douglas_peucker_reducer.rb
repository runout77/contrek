# frozen_string_literal: true

module Contrek
  module Reducers
    class DouglasPeuckerReducer < Reducer
      TOLERANCE_SQUARED = 1.0

      def reduce!
        count = @points.length
        return @points if count < 4

        first_index = extreme_index_by_x
        second_index = farthest_index_from(first_index)

        return @points if second_index == first_index

        keep = Array.new(count, false)
        keep[first_index] = true
        keep[second_index] = true

        simplify_arc!(first_index, second_index, keep)
        simplify_arc!(second_index, first_index, keep)

        compact_ring!(keep)
      end

      private

      def extreme_index_by_x
        points = @points
        index = 0
        best = 0
        best_x = points[0][:x]

        while (index += 1) < points.length
          x = points[index][:x]

          if x < best_x
            best_x = x
            best = index
          end
        end

        best
      end

      def farthest_index_from(origin_index)
        points = @points
        origin = points[origin_index]

        ox = origin[:x]
        oy = origin[:y]

        best_index = origin_index
        best_distance = -1

        index = 0

        while index < points.length
          dx = points[index][:x] - ox
          dy = points[index][:y] - oy
          distance = dx * dx + dy * dy

          if distance > best_distance
            best_distance = distance
            best_index = index
          end

          index += 1
        end

        best_index
      end

      def simplify_arc!(first_index, last_index, keep)
        count = @points.length
        stack = [first_index, last_index]

        until stack.empty?
          last = stack.pop
          first = stack.pop

          split = farthest_on_arc(first, last, count)
          next unless split

          keep[split] = true

          stack << first << split if next_index(first, count) != split
          stack << split << last if next_index(split, count) != last
        end
      end

      def farthest_on_arc(first_index, last_index, count)
        points = @points

        first = points[first_index]
        last = points[last_index]

        ax = first[:x]
        ay = first[:y]
        bx = last[:x]
        by = last[:y]

        abx = bx - ax
        aby = by - ay
        length_squared = abx * abx + aby * aby

        max_distance = TOLERANCE_SQUARED
        split_index = nil
        index = next_index(first_index, count)

        while index != last_index
          point = points[index]

          distance = if length_squared.zero?
            dx = point[:x] - ax
            dy = point[:y] - ay
            dx * dx + dy * dy
          else
            point_segment_distance_squared(
              point[:x],
              point[:y],
              ax,
              ay,
              bx,
              by,
              abx,
              aby,
              length_squared
            )
          end

          if distance > max_distance
            max_distance = distance
            split_index = index
          end

          index = next_index(index, count)
        end

        split_index
      end

      def point_segment_distance_squared(
        px, py,
        ax, ay,
        bx, by,
        abx, aby,
        length_squared
      )
        apx = px - ax
        apy = py - ay

        dot = apx * abx + apy * aby

        if dot <= 0
          apx * apx + apy * apy
        elsif dot >= length_squared
          bpx = px - bx
          bpy = py - by
          bpx * bpx + bpy * bpy
        else
          cross = apx * aby - apy * abx
          (cross * cross).fdiv(length_squared)
        end
      end

      def next_index(index, count)
        (index + 1 == count) ? 0 : index + 1
      end

      def compact_ring!(keep)
        points = @points
        read_index = 0
        write_index = 0

        while read_index < points.length
          if keep[read_index]
            points[write_index] = points[read_index]
            write_index += 1
          end

          read_index += 1
        end

        points.slice!(write_index, points.length - write_index)
        points
      end
    end
  end
end
