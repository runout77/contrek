module Contrek
  module Finder
    Result = Struct.new(:polygons, :metadata_hash) do
      def points
        polygons
      end

      def metadata
        metadata_hash
      end
    end
  end
end
