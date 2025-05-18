RSpec.shared_examples "heavy" do
  describe "simple cases" do
    it "scans poly 1160x772", sample_1160x772: true do
      filename = "sample_1160x772.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(@png_not_matcher_color)
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      # store_sample(polygonfinder,filename)
      saved_poly = YAML.load_file("./spec/files/coordinates/#{filename}.yml")
      expect(result[:polygons]).to eq(saved_poly)
    end
    it "scans poly 1200x800", sample_1200x800: true do
      filename = "sample_1200x800.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      # store_sample(polygonfinder,filename)
      saved_poly = YAML.load_file("./spec/files/coordinates/#{filename}.yml")
      expect(result[:polygons]).to eq(saved_poly)
    end
    it "scans poly 1200x1192", sample_1200x1192: true do
      filename = "sample_1200x1192.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      # store_sample(polygonfinder,filename,@result)
      saved_poly = YAML.load_file("./spec/files/coordinates/#{filename}.yml")
      expect(result[:polygons]).to eq(saved_poly)
    end
  end

  def store_sample(polygonfinder, filename, result)
    test_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}")
    polygonfinder.draw_shapelines(test_bitmap)
    polygonfinder.draw_polygons(test_bitmap)
    test_bitmap.save("./spec/files/images/processed_#{filename}")
    # File.write("./spec/coordinates/#{filename}.yml", @result[:polygons].to_yaml)
  end
end
