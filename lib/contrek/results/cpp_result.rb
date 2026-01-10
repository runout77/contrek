module Contrek
  module Results
    class CPPFinder::Result
      def points
        raw_list = polygons.to_a
        @to_points ||= raw_list.map do |polygon|
          {outer: self.class.to_points(polygon[:outer]),
           inner: polygon[:inner].map { |s| self.class.to_points(s) }}
        end
      end

      def total_time
        metadata[:benchmarks].values.sum
      end

      def self.to_points(flat_polygon)
        flat_polygon.each_slice(2).map { |x, y| {x: x, y: y} }
      end
    end
  end
end
