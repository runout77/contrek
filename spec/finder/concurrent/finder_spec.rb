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
  end

  describe "shared_test" do
    include_examples "finder"
  end

  describe "shared_test" do
    include_examples "finder_extension"
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
