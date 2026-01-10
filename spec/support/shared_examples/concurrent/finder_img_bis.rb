RSpec.shared_examples "finder_img_bis" do
  describe "various image cases part 2" do
    it "divides image into large number of tiles (1200x800) clockwise" do
      filename = "sample_1200x800"
      workers = 120

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      color = @color_class.new(r: 251, g: 251, b: 251, a: 255)
      rgb_matcher = @png_not_matcher.new(color.to_rgb_raw)
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info

      puts result.metadata[:benchmarks].inspect
      expect(result.points).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
    end

    it "divides image into large number of tiles (1160x772) clockwise" do
      filename = "sample_1160x772"
      workers = 120

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      puts result.metadata[:benchmarks].inspect

      expect(result.points).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
    end

    it "divides image into large number of tiles (3000x3000) clockwise" do
      skip
      filename = "sample_3000x3000"
      workers = 300

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      puts result.metadata[:benchmarks].inspect

      expect(result.points).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
    end

    it "divides image into large number of tiles (1024x1024) clockwise" do
      filename = "sample_1024x1024"
      workers = 120

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      puts result.metadata[:benchmarks].inspect

      expect(result.points).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
    end

    it "divides spiral into large number of tiles (1024x1024) clockwise" do
      filename = "sample_1024x1024b"
      workers = 100

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :o}
      ).process_info
      puts result.metadata[:benchmarks].inspect

      expect(result.points).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
    end
  end
end
