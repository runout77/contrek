RSpec.describe Contrek::Finder::PolygonFinder, type: :class do
  describe "PolygonFinder on image" do
    it "trace contourn on sample image" do
      filename = "sample_1200x800.png"
      png_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}")
      color = Contrek::Bitmaps::RgbCppColor.new(r: 251, g: 251, b: 251, a: 255)
      rgb_matcher = Contrek::Matchers::ValueNotMatcher.new(color.raw)
      polygonfinder = Contrek::Finder::PolygonFinder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, compress: {uniq: true, linear: true}})
      polygonfinder.process_info
      polygonfinder.draw_shapelines(png_bitmap)
      polygonfinder.draw_polygons(png_bitmap)
      same_image?(png_bitmap.to_tmp_file.path, "./spec/files/stored_samples/#{filename}")
    end

    it "trace contourn on sample image 2" do
      filename = "sample_300x300.png"
      png_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}")
      color = Contrek::Bitmaps::RgbCppColor.new(r: 1, g: 1, b: 1, a: 255)
      rgb_matcher = Contrek::Matchers::Matcher.new(color.raw)
      polygonfinder = Contrek::Finder::PolygonFinder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, compress: {uniq: true, linear: true}})
      polygonfinder.process_info
      polygonfinder.draw_shapelines(png_bitmap)
      polygonfinder.draw_polygons(png_bitmap)
      same_image?(png_bitmap.to_tmp_file.path, "./spec/files/stored_samples/#{filename}")
    end
  end
end
