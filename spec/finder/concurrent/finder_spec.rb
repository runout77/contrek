# frozen_string_literal: true

RSpec.describe Contrek::Concurrent::Finder, type: :class do
  before do
    @ruby_bitmap_class = Contrek::Bitmaps::ChunkyBitmap
    @ruby_matcher = Contrek::Matchers::ValueNotMatcher.new(" ")
    @matcher = @ruby_matcher
    @polygon_finder_class = Contrek::Concurrent::Finder
    @bitmap_class = @ruby_bitmap_class
    @png_bitmap_class = Contrek::Bitmaps::PngBitmap
    @png_not_matcher = Contrek::Matchers::ValueNotMatcher
    @color_class = Contrek::Bitmaps::RgbColor
    @simple_polygon_finder = Contrek::Finder::PolygonFinder
    @merger = Contrek::Concurrent::HorizontalMerger
    @vertical_merger = Contrek::Concurrent::VerticalMerger
    @svg_streaming_merger = Contrek::Concurrent::SvgStreamingMerger
    @geo_json_streaming_merger = Contrek::Concurrent::GeoJsonStreamingMerger
    @result = Contrek::Finder::Result
    @streaming_file = Tempfile
  end

  describe "base tests", base: true do
    it "case during cpp porting" do
      chunk = "  XXXXXXXXXXX   " \
              "  XX       XX   " \
              "  XX       XX   " \
              "  XX       XX   " \
              "  XXXXXXXXXXX   "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 13, y: 0}, {x: 13, y: 5}, {x: 2, y: 5}, {x: 2, y: 0}], inner: [[{x: 4, y: 1}, {x: 4, y: 4}, {x: 11, y: 4}, {x: 11, y: 1}]]}])
    end
  end

  describe "concurrent" do
    include_examples "finder"
  end

  describe "concurrent" do
    include_examples "finder_extension"
  end

  describe "concurrent" do
    include_examples "connectivity"
  end

  describe "concurrent" do
    include_examples "finder_img"
  end

  describe "concurrent" do
    include_examples "finder_img_bis"
  end

  describe "concurrent" do
    include_examples "multiprocessing"
  end

  describe "concurrent" do
    include_examples "concurrent_treemap"
  end

  describe "concurrent" do
    include_examples "generic"
  end

  describe "concurrent" do
    include_examples "merging"
  end

  describe "concurrent" do
    include_examples "performances"
  end
end
