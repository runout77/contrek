# frozen_string_literal: true

module Contrek
  module Finder
    Result = Struct.new(:polygons, :metadata) do
      include Shared::Result

      def points
        polygons
      end
    end
  end
end
