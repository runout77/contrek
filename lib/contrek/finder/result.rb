# frozen_string_literal: true

module Contrek
  module Finder
    Result = Struct.new(:polygons, :metadata) do
      include Shared::Result

      def points
        polygons
      end

      def sort_polygons!
        polygons.sort_by! do |polygon|
          [polygon[:bounds][:min_y], polygon[:bounds][:min_x]]
        end
      end
    end
  end
end
