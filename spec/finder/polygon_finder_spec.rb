RSpec.describe Contrek::Finder::PolygonFinder, type: :class do
  before do
    @matcher = Contrek::Matchers::ValueNotMatcher.new("0")
    @polygon_finder_class = Contrek::Finder::PolygonFinder
    @bitmap_class = Contrek::Bitmaps::ChunkyBitmap
    @png_bitmap_class = Contrek::Bitmaps::PngBitmap
    @png_not_matcher = Contrek::Matchers::ValueNotMatcher
    @png_not_matcher_color = 4294967295
  end

  describe "shared_test", simples: true do
    before do
      @matcher = Contrek::Matchers::ValueNotMatcher.new(" ")
    end
    include_examples "simples"
  end

  describe "shared_test", complex: true do
    include_examples "complex"
  end

  describe "shared_test", treemap: true do
    before do
      @matcher = Contrek::Matchers::ValueNotMatcher.new(" ")
    end
    include_examples "treemap"
  end

  describe "shared_test", heavy: true do
    include_examples "heavy"
  end

  describe "shared_test", connections: true do
    before do
      @matcher = Contrek::Matchers::ValueNotMatcher.new(" ")
    end
    include_examples "connections"
  end

  describe "bitmap", bitmap: true do
    it "allocates a blank area to draw polygon" do
      raw_bitmap = Contrek::Bitmaps::RawBitmap.new(w: 10, h: 10)
      not_matcher = Contrek::Matchers::ValueNotMatcher.new(raw_bitmap.rgb_value_at(0, 0))
      polygons = [{
        outer: [{x: 1, y: 1}, {x: 1, y: 8}, {x: 8, y: 8}, {x: 8, y: 1}],
        inner: [[{x: 2, y: 2}, {x: 2, y: 7}, {x: 7, y: 7}, {x: 7, y: 2}]]
      }]
      Contrek::Bitmaps::Painting.direct_draw_polygons(polygons, raw_bitmap)
      result = @polygon_finder_class.new(raw_bitmap, not_matcher, nil, compress: {uniq: true, linear: true}).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 1, y: 1}, {x: 1, y: 8}, {x: 8, y: 8}, {x: 8, y: 1}], inner: [[{x: 2, y: 3}, {x: 7, y: 3}, {x: 7, y: 6}, {x: 2, y: 6}, {x: 2, y: 4}]]}])
    end
  end
end
