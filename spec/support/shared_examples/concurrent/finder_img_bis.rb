RSpec.shared_examples "finder_img_bis" do
  describe "various image cases part 2" do
    it "divides image into large number of tiles (1200x800) clockwise" do
      filename = "sample_1200x800"
      workers = 120

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      color = @color_class.new(r: 251, g: 251, b: 251, a: 255)
      rgb_matcher = @png_not_matcher.new(color.raw)
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

    it "divides image into 4 tiles (1024x1024) clockwise" do
      filename = "graphs_1024x1024"
      workers = 4

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      puts result.metadata[:benchmarks].inspect

      expect(result.points).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "divides image into 4 tiles (1024x1024) clockwise and computes treemap" do
      filename = "shapes_1024x1024"
      workers = 4

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {versus: :a, number_of_tiles: workers, treemap: true}
      ).process_info
      expect(result.points).to match_expected_polygons(filename, number_of_tiles: workers)
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [0, 0], [2, 0], [-1, -1], [4, 0], [-1, -1], [5, 0], [-1, -1], [8, 0], [9, 0], [-1, -1], [11, 1], [-1, -1], [13, 0], [1, 0], [15, 0], [-1, -1], [17, 0], [-1, -1], [19, 0], [6, 0], [21, 0], [-1, -1], [23, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [35, 0], [36, 0], [-1, -1], [20, 0], [39, 0], [-1, -1], [41, 2], [42, 0], [-1, -1], [25, 1], [45, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [58, 0], [59, 0], [60, 0], [38, 0], [62, 0], [63, 0], [-1, -1], [65, 0], [66, 0], [-1, -1], [68, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [74, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1]])
    end

    it "divides image into 4 tiles (1024x1024) clockwise" do
      filename = "shapes_1024x1024"
      workers = 150

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, treemap: true}
      ).process_info
      puts result.metadata[:benchmarks].inspect
      expect(result.points).to match_expected_polygons(filename, number_of_tiles: workers)
    end
  end
end
