RSpec.describe CPPPolygonFinder, type: :class do
  before do
    @matcher = CPPValueNotMatcher.new("0")
    @polygon_finder_class = CPPPolygonFinder
    @bitmap_class = CPPBitMap
    @png_bitmap_class = CPPPngBitMap
    @png_not_matcher = CPPRGBNotMatcher
    @png_not_matcher_color = 0x00FFFFFF
  end

  describe "node test" do
    it "verify costants difference" do
      chunk = "0000000000000000" \
                  "0000000000000000" \
                  "000000AAAAAA0000" \
                  "000000BB00FF0000" \
                  "000000CC00EE0000" \
                  "000000DDDDDD0000" \
                  "0000000000000000"
      bitmap = CPPBitMap.new(chunk, 16)
      matcher = CPPValueNotMatcher.new("0")
      polygonfinder = CPPPolygonFinder.new(bitmap, matcher, nil, {versus: "o", compress: {linear: true, visvalingam: {tolerance: 1}}})
      pi = polygonfinder.process_info

      expect(pi[:groups]).to eq 1
      expect(pi[:named_sequence]).to eq("AFEDCBA")
    end
  end

  describe "shared_test", simples: true do
    include_examples "simples"
  end

  describe "shared_test", complex: true do
    include_examples "complex"
  end

  describe "shared_test", heavy: true do
    include_examples "heavy"
  end

  describe "shared_test", treemap: true do
    include_examples "treemap"
  end
end
