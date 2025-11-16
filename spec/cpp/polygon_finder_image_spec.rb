RSpec.describe CPPPolygonFinder, type: :class do
  describe "CPPPolygonFinder on image" do
    it "trace contourn on sample image" do
      filename = "sample_1200x800.png"
      png_bitmap = CPPPngBitMap.new("./spec/files/images/#{filename}")
      rgb_matcher = CPPRGBNotMatcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = CPPPolygonFinder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, compress: {uniq: true, linear: true}})
      result = polygonfinder.process_info
      png_image = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}")
      Contrek::Bitmaps::Painting.direct_draw_polygons(result[:polygons], png_image)
      same_image?(png_image.to_tmp_file.path, "./spec/files/stored_samples/#{filename}")
    end

    it "trace contourn on sample spiral image" do
      filename = "sample_1024x1024b.png"
      png_bitmap = CPPPngBitMap.new("./spec/files/images/#{filename}")
      rgb_matcher = CPPRGBNotMatcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = CPPPolygonFinder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, compress: {uniq: true, linear: true}})
      result = polygonfinder.process_info
      png_image = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}")
      Contrek::Bitmaps::Painting.direct_draw_polygons(result[:polygons], png_image)
      same_image?(png_image.to_tmp_file.path, "./spec/files/stored_samples/#{filename}")
    end

    it "read png from iostring" do
      png_bitmap = CPPRemotePngBitMap.new("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg==")
      expect(png_bitmap.w).to eq(1)
      expect(png_bitmap.h).to eq(1)
    end
  end
end
