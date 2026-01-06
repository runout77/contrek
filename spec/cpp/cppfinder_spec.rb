RSpec.describe Contrek::Cpp::CPPConcurrentFinder, type: :class do
  before do
    @matcher = CPPValueNotMatcher.new(" ")
    @polygon_finder_class = Contrek::Cpp::CPPConcurrentFinder
    @bitmap_class = CPPBitMap
    @png_bitmap_class = CPPPngBitMap
    @png_not_matcher = CPPRGBNotMatcher
    @png_not_matcher_color = 0x00FFFFFF
    @color_class = Contrek::Bitmaps::RgbColor

    @ruby_bitmap_class = Contrek::Bitmaps::ChunkyBitmap
    @ruby_matcher = Contrek::Matchers::ValueNotMatcher.new(" ")
  end

  describe "node test" do
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
      expect(result[:polygons]).to eq([
        {outer: [{x: 4, y: 0}, {x: 3, y: 1}, {x: 3, y: 3}, {x: 4, y: 4}, {x: 2, y: 4}, {x: 2, y: 0}],
         inner: []},
        {outer: [{x: 12, y: 0}, {x: 12, y: 4}, {x: 9, y: 4}, {x: 11, y: 3}, {x: 11, y: 1}, {x: 9, y: 0}],
         inner: []}
      ])
    end
    # this test has a different behaviour on ruby side is:
    # [{:inner=>[[{:x=>3, :y=>3}, {:x=>3, :y=>1}, {:x=>11, :y=>1}, {:x=>11, :y=>3}]]
    it "case during cpp porting" do
      chunk = "  XXXXXXXXXXX   " \
              "  XX       XX   " \
              "  XX       XX   " \
              "  XX       XX   " \
              "  XXXXXXXXXXX   "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: "o", compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq(
        [{outer: [{x: 7, y: 0}, {x: 12, y: 0}, {x: 12, y: 4}, {x: 2, y: 4}, {x: 2, y: 0}],
          inner: [[{x: 3, y: 1}, {x: 3, y: 3}, {x: 11, y: 3}, {x: 11, y: 1}]]}]
      )
    end
  end

  describe "shared_test" do
    include_examples "finder_extension"
  end

  describe "shared_test" do
    include_examples "finder"
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
end
