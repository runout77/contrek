module Contrek
  module Concurrent
    class ClippedPolygonFinder < Finder::PolygonFinder
      attr_reader :start_x, :end_x

      def initialize(bitmap:, matcher:, start_x:, end_x:, options: {})
        @start_x = start_x
        @end_x = end_x
        super(bitmap, matcher, nil, options)
      end
    end
  end
end
