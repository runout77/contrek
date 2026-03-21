RSpec.describe CPPPolygonFinder, type: :class do
  before do
    @matcher = CPPValueNotMatcher.new(" ")
    @polygon_finder_class = CPPPolygonFinder
    @bitmap_class = CPPBitMap
    @png_bitmap_class = CPPPngBitMap
    @png_not_matcher = CPPRGBNotMatcher
    @png_not_matcher_color = Contrek::Bitmaps::RgbCppColor.new(r: 255, g: 255, b: 255, a: 255).raw
  end

  describe "base tests", base: true do
    it "verify costants difference" do
      chunk = "                " \
                  "                " \
                  "      AAAAAA    " \
                  "      BB  FF    " \
                  "      CC  EE    " \
                  "      DDDDDD    " \
                  "                "
      bitmap = CPPBitMap.new(chunk, 16)
      matcher = CPPValueNotMatcher.new(" ")
      polygonfinder = CPPPolygonFinder.new(bitmap, matcher, nil, {versus: "o", named_sequences: true, compress: {linear: true, visvalingam: {tolerance: 1}}})
      pi = polygonfinder.process_info
      expect(pi.metadata[:groups]).to eq 1
      expect(pi.metadata[:named_sequence]).to eq("AFEDCBA")
    end
  end

  describe "shared_test", simples: true do
    include_examples "simples"
  end

  describe "shared_test", complex: true do
    include_examples "complex"
  end

  describe "shared_test", treemap: true do
    include_examples "treemap"
  end

  describe "shared_test", heavy: true do
    include_examples "heavy"
  end

  describe "shared_test", connections: true do
    include_examples "connections"
  end

  describe "shared_test", strict_bounds: true do
    include_examples "strict_bounds"
  end
end
