# frozen_string_literal: true

RSpec.describe Contrek::Finder::PolygonFinder, type: :class do
  before do
    @matcher = Contrek::Matchers::ValueNotMatcher.new(" ")
    @polygon_finder_class = Contrek::Finder::PolygonFinder
    @bitmap_class = Contrek::Bitmaps::ChunkyBitmap
    @png_bitmap_class = Contrek::Bitmaps::PngBitmap
    @png_not_matcher = Contrek::Matchers::ValueNotMatcher
    @png_not_matcher_color = 4294967295
  end

  describe "base tests" do
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
      expect(result.points).to eq([{outer: [{x: 1, y: 1}, {x: 1, y: 9}, {x: 9, y: 9}, {x: 9, y: 1}], inner: [[{x: 3, y: 3}, {x: 7, y: 3}, {x: 7, y: 7}, {x: 3, y: 7}, {x: 3, y: 4}]]}])
    end
  end

  describe "polygon_finder", base: true do
    include_examples "base"
  end

  describe "polygon_finder", simples: true do
    include_examples "simples"
  end

  describe "polygon_finder", complex: true do
    include_examples "complex"
  end

  describe "polygon_finder", treemap: true do
    include_examples "treemap"
  end

  describe "polygon_finder", heavy: true do
    include_examples "heavy"
  end

  describe "polygon_finder", connections: true do
    include_examples "connections"
  end
end
