RSpec.describe Contrek::Cpp::CPPConcurrentFinder, type: :class do
  before do
    @matcher = CPPValueNotMatcher.new(" ")
    @polygon_finder_class = Contrek::Cpp::CPPConcurrentFinder
    @bitmap_class = CPPBitMap
    @png_bitmap_class = CPPPngBitMap
    @png_not_matcher = CPPRGBNotMatcher
    @color_class = Contrek::Bitmaps::RgbCppColor
    @ruby_bitmap_class = Contrek::Bitmaps::ChunkyBitmap
    @ruby_matcher = Contrek::Matchers::ValueNotMatcher.new(" ")
    @simple_polygon_finder = CPPPolygonFinder
    @merger = Contrek::Cpp::CPPConcurrentHorizontalMerger
    @vertical_merger = Contrek::Cpp::CPPConcurrentVerticalMerger
    @result = Contrek::Cpp::CPPResult
  end

  describe "base tests", base: true do
    it "verify costants difference" do
      chunk = "  XXXXXXXXXXX   " \
              "  XX       XX   " \
              "  XX       XX   " \
              "  XX       XX   " \
              "  XXXXXXXXXXX   "
      bitmap = CPPBitMap.new(chunk, 16)
      matcher = CPPValueNotMatcher.new(" ")
      polygonfinder = CPPFinder.new(1, bitmap, matcher, {versus: "o", number_of_tiles: 3, compress: {linear: true, visvalingam: {tolerance: 1}}})
      result = polygonfinder.process_info
      expect(result.points).to eq([
        {outer: [{x: 4, y: 0}, {x: 3, y: 1}, {x: 3, y: 3}, {x: 4, y: 4}, {x: 2, y: 4}, {x: 2, y: 0}],
         inner: []},
        {outer: [{x: 12, y: 0}, {x: 12, y: 4}, {x: 9, y: 4}, {x: 11, y: 3}, {x: 11, y: 1}, {x: 9, y: 0}],
         inner: []}
      ])
    end
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
      expect(result.points).to eq(
        [{outer: [{x: 7, y: 0}, {x: 12, y: 0}, {x: 12, y: 4}, {x: 2, y: 4}, {x: 2, y: 0}],
          inner: [[{x: 3, y: 1}, {x: 3, y: 3}, {x: 11, y: 3}, {x: 11, y: 1}]]}]
      )
    end
    it "allocates a blank area to draw polygon" do
      raw_bitmap = CPPRawBitMap.new
      expect(raw_bitmap.w).to eq(0)
      expect(raw_bitmap.h).to eq(0)
      raw_bitmap.define(20, 20, 4, true)
      expect(raw_bitmap.w).to eq(20)
      expect(raw_bitmap.h).to eq(20)
      4.upto(5) do |y|
        5.upto(8) do |x|
          raw_bitmap.draw_pixel(x, y, 1, 0, 0, 0)
        end
      end
      not_matcher = CPPRGBNotMatcher.new(raw_bitmap.rgb_value_at(0, 0))
      result = CPPPolygonFinder.new(raw_bitmap, not_matcher, nil, {compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 5, y: 4}, {x: 5, y: 5}, {x: 8, y: 5}, {x: 8, y: 4}], inner: []}])
    end
  end

  describe "shared_test" do
    include_examples "finder"
  end

  describe "shared_test" do
    include_examples "finder_extension"
  end

  describe "shared_test" do
    include_examples "connectivity"
  end

  describe "shared_test" do
    include_examples "finder_img"
  end

  describe "shared_test" do
    include_examples "finder_img_bis"
  end

  describe "shared_test" do
    include_examples "multiprocessing"
  end

  describe "shared_test" do
    include_examples "concurrent_treemap"
  end
end
