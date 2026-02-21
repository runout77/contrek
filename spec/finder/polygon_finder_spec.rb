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
end
