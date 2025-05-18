require "benchmark"
# todo
# - builtin png decoder which makes blocks to pass vert_nodes
# - work only in clockwise (no more :o e :a); finally for coords use push_back on :a and
#   push_front on :o
module Contrek
  module Finder
    class PolygonFinder
      NodeDescriptor = Struct.new(:node, :a, :o)
      def initialize(bitmap, matcher, test_bitmap = nil, options = {})
        @options = {versus: :a}.merge(options)
        sanitize_options
        @source_bitmap = bitmap
        @matcher = matcher

        @test_bitmap = test_bitmap
        @node_cluster = NodeCluster.new(@source_bitmap.h, @options)
        @reports = {}

        # 1 finds matching blocks
        @reports[:scan] = Benchmark.measure do
          scan
        end

        # 2 builds relational spatially tree map
        @reports[:build_tangs_sequence] = Benchmark.measure do
          @node_cluster.build_tangs_sequence
        end

        # 3 plotting
        @reports[:plot] = Benchmark.measure do
          @node_cluster.plot(@test_bitmap)
        end

        # 4 compress
        @reports[:compress] = Benchmark.measure do
          if @options.has_key?(:compress)
            @node_cluster.compress_coords
          end
        end
      end

      def sanitize_options
        @options[:versus] = :a unless @options[:versus] == :a || @options[:versus] == :o
      end

      # infos
      def process_info
        {named_sequence: @node_cluster.sequences.map { |list| list.map(&:name).join }.join("-"),
         groups: @node_cluster.sequences.size,
         groups_names: @node_cluster.root_nodes.map(&:name).join,
         polygons: @node_cluster.polygons,
         benchmarks: format_benchmarks,
         treemap: (@node_cluster.treemap if @options.has_key?(:treemap))}
      end

      def get_shapelines
        shapes = []
        @node_cluster.vert_nodes.each do |line|
          line.each do |node|
            shapes << {start_x: node.min_x, end_x: node.max_x, y: node.y}
          end
        end
        shapes
      end

      def draw_polygons(png_image)
        Contrek::Bitmaps::Painting.direct_draw_polygons(@node_cluster.polygons, png_image)
      end

      def draw_shapelines(png_image)
        slines = get_shapelines
        color = ChunkyPNG::Color("blue @ 1.0")
        slines.each do |sline|
          png_image.draw_line(sline[:start_x], sline[:y], sline[:end_x], sline[:y], color)
        end
      end

      private

      # image scan
      def scan
        last_color = nil
        matching = false
        min_x = 0
        max_x = 0
        @source_bitmap.scan do |x, y, color|
          if @matcher.match?(color) && matching == false
            min_x = x
            last_color = color
            matching = true
            if x == (@source_bitmap.w - 1)
              max_x = x
              Contrek::Finder::Node.new(@node_cluster, min_x, max_x, y, last_color)
              matching = false
            end
          elsif @matcher.unmatch?(color) && matching == true
            max_x = x - 1
            Contrek::Finder::Node.new(@node_cluster, min_x, max_x, y, last_color)
            matching = false
          elsif x == (@source_bitmap.w - 1) && matching == true
            max_x = x
            Contrek::Finder::Node.new(@node_cluster, min_x, max_x, y, last_color)
            matching = false
          end
        end
      end

      def format_benchmarks
        r = {}
        total = 0
        @reports.each do |k, v|
          r[k] = (v.real * 1000).round(3)
          total += v.real * 1000
        end
        r[:total] = total.round(3)
        r
      end
    end
  end
end
