module Contrek
  module Finder
    Result = Struct.new(:polygons, :metadata) do
      def points
        polygons
      end
    end
  end
end
