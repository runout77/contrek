module Contrek
  module Cpp
    class CPPResult
      def polygons=(list)
        @polygons_storage = list
      end

      def metadata=(map)
        @metadata_storage = {
          width: 0,
          height: 0,
          benchmarks: {},
          treemap: []
        }.merge(map)
      end

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

      def self.to_numpy(polygons_data)
        polygons_data.map do |poly|
          {outer: poly[:outer].flat_map { |p| [p[:x], p[:y]] },
           inner: (poly[:inner] || []).map { |hole| hole.flat_map { |p| [p[:x], p[:y]] } },
           bounds: poly[:bounds]}
        end
      end
    end
  end
end
