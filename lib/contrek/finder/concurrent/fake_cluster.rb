module Contrek
  module Concurrent
    class FakeCluster < Finder::NodeCluster
      def initialize(polygons, options)
        @options = options
        @polygons = polygons
      end
    end
  end
end
