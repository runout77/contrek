RSpec.shared_examples "heavy" do
  describe "simple cases" do
    it "scans poly 1160x772", sample_1160x772: true do
      filename = "sample_1160x772.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(@png_not_matcher_color)
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      # store_sample(polygonfinder,filename,result,png_bitmap)
      saved_poly = YAML.load_file("./spec/files/coordinates/#{filename}.yml")
      expect(result.points).to eq(saved_poly)
    end
    it "scans poly 1200x800", sample_1200x800: true do
      filename = "sample_1200x800.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      # store_sample(polygonfinder,filename,result,png_bitmap)
      saved_poly = YAML.load_file("./spec/files/coordinates/#{filename}.yml")
      expect(result.points).to eq(saved_poly)
    end
    it "scans poly 1200x1192", sample_1200x1192: true do
      filename = "sample_1200x1192.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      # store_sample(polygonfinder,filename,result,png_bitmap)
      saved_poly = YAML.load_file("./spec/files/coordinates/#{filename}.yml")
      expect(result.points).to eq(saved_poly)
    end
    it "scans poly 3000x3000", sample_3000x3000: true do
      skip
      filename = "sample_3000x3000.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      puts result[:benchmarks].inspect
      expect(result.points).to eq(JSON.parse(File.read("./spec/files/coordinates/#{filename}.json"), symbolize_names: true))
    end
  end

  def store_sample(polygonfinder, filename, result, bitmap)
    test_bitmap = Contrek::Bitmaps::CustomBitmap.new(w: bitmap.w, h: bitmap.h, color: ChunkyPNG::Color::WHITE)
    Contrek::Bitmaps::Painting.direct_draw_polygons(result.points, test_bitmap)
    test_bitmap.save("./spec/files/stored_samples/#{filename}")
    File.write("./spec/coordinates/#{filename}.yml", @result.points.to_yaml)
  end
end
