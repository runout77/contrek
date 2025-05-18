# https://bost.ocks.org/mike/simplify/
# https://github.com/metteo/jts/blob/master/jts-core/src/main/java/com/vividsolutions/jts/simplify/VWLineSimplifier.java

module Contrek
  module Reducers
    class VisvalingamReducer < Reducer
      def initialize(points: list_of_points, options: {})
        @pts = points
        @tolerance = options[:tolerance] * options[:tolerance]
      end

      def reduce!
        @pts.replace simplify
      end

      def self.simplify(pts, distance_tolerance)
        simp = Polygon::Reducers::VisvalingamReducer.new(pts, distance_tolerance)
        simp.simplify
      end

      def simplify
        vw_line = Vertex.build_line(@pts)
        min_area = @tolerance
        loop do
          min_area = simplify_vertex(vw_line)
          break if min_area >= @tolerance
        end
        vw_line.get_coordinates
      end

      private

      def simplify_vertex(vw_line)
        curr = vw_line
        min_area = curr.get_area
        min_vertex = nil
        until curr.nil?
          area = curr.get_area
          if area < min_area
            min_area = area
            min_vertex = curr
          end
          curr = curr.next
        end
        min_vertex.remove if !min_vertex.nil? && min_area < @tolerance
        return -1 if !vw_line.is_live
        min_area
      end
    end

    class Triangle
      def self.area(a, b, c)
        (((c[:x] - a[:x]) * (b[:y] - a[:y]) - (b[:x] - a[:x]) * (c[:y] - a[:y])) / 2).abs
      end
    end

    class Vertex
      attr_reader :pt, :next, :prev
      MAX_AREA = Float::MAX
      def initialize(pt)
        @pt = pt
        @prev = nil
        @next = nil
        @area = MAX_AREA
        @is_live = true
      end

      def self.build_line(pts)
        first = nil
        prev = nil
        pts.each_with_index do |pt, i|
          v = Vertex.new(pts[i])
          first = v if first.nil?

          v.setPrev(prev)
          if !prev.nil?
            prev.setNext(v)
            prev.updateArea
          end
          prev = v
        end
        first
      end

      def setPrev(prev)
        @prev = prev
      end

      def setNext(nextp)
        @next = nextp
      end

      def updateArea
        if @prev.nil? || @next.nil?
          @area = MAX_AREA

          return
        end
        @area = Triangle.area(@prev.pt, pt, @next.pt).abs
      end

      def get_area
        @area
      end

      attr_reader :is_live

      def remove
        tmp_prev = @prev
        tmp_next = @next
        result = nil
        if !prev.nil?
          @prev.setNext(tmp_next)
          @prev.updateArea
          result = prev
        end
        if !@next.nil?
          @next.setPrev(tmp_prev)
          @next.updateArea
          result = @next if result.nil?
        end

        @is_live = false
        result
      end

      def get_coordinates
        coords = []
        curr = self
        loop do
          coords << curr.pt
          curr = curr.next
          break if curr.nil?
        end
        coords
      end
    end
  end
end
