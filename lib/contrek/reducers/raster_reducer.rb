# frozen_string_literal: true

module Contrek
  module Reducers
    class RasterReducer < Reducer
      def reduce!
        versus = @opts[:versus]
        to_raster_polygon!(@points, versus)
      end

      private

      def to_raster_polygon!(points, versus)
        n = points.size
        return points if n.zero?

        outer = versus == :o
        first_x = points[0][:x]
        first_y = points[0][:y]
        prev_x = points[-1][:x]
        prev_y = points[-1][:y]
        points.each_index do |i|
          curr_x = points[i][:x]
          curr_y = points[i][:y]
          if i + 1 < n
            next_x = points[i + 1][:x]
            next_y = points[i + 1][:y]
          else
            next_x = first_x
            next_y = first_y
          end
          in_side = segment_pole(
            curr_x - prev_x,
            curr_y - prev_y,
            outer
          )
          out_side = segment_pole(
            next_x - curr_x,
            next_y - curr_y,
            outer
          )
          x = curr_x
          y = curr_y
          [in_side, out_side].uniq.each do |side|
            case side
            when :south then y -= 1
            when :east then x -= 1
            end
          end
          points[i][:x] = x
          points[i][:y] = y
          prev_x = curr_x
          prev_y = curr_y
        end
        points
      end

      def segment_pole(dx, dy, clockwise)
        sx = dx <=> 0
        sy = dy <=> 0
        case [sx, sy]
        when [0, 1] then clockwise ? :east : :west
        when [1, 0] then clockwise ? :north : :south
        when [0, -1] then clockwise ? :west : :east
        when [-1, 0] then clockwise ? :south : :north
        else
          raise ArgumentError, "Non-axial segment dx=#{dx} dy=#{dy}!"
        end
      end
    end
  end
end
