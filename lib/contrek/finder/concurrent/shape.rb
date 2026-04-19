module Contrek
  module Concurrent
    class Shape
      attr_accessor :outer_polyline, :inner_polylines, :merged_to_shape, :parent_inner_polyline,
        :reassociation_skip
      attr_reader :parent_shape, :children_shapes

      def initialize
        @parent_shape = nil
        @merged_to_shape = nil
        @parent_inner_polyline = nil
        @children_shapes = []
        @reassociation_skip = false
      end

      def self.init_by(set_outer_polyline, set_inner_polylines)
        s = Shape.new
        s.outer_polyline = set_outer_polyline
        s.inner_polylines = set_inner_polylines
        s
      end

      def clear_inner!
        @inner_polylines.clear
      end

      def set_parent_shape(shape)
        @parent_shape&.children_shapes&.delete(self)
        @parent_shape = shape
        shape.children_shapes << self if shape
      end

      def info
        "Shape (outer_polyline = #{outer_polyline.named}, children count = #{@children_shapes.size}"
      end
    end
  end
end
