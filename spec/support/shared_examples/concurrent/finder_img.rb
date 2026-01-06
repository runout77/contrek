RSpec.shared_examples "finder_img" do
  describe "various image cases" do
    it "divides large image into growing number of tiles" do
      filename = "sample_1500x180"
      [10, 30, 40, 60, 100].each do |workers|
        puts workers
        png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
        rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
        result = @polygon_finder_class.new(
          bitmap: png_bitmap,
          matcher: rgb_matcher,
          options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
        ).process_info

        expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
      end
    end

    it "divides complex sample png into many tiles" do
      filename = "sample_300x300"
      workers = 9
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(10, 10))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      puts result[:benchmarks].inspect
      expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "divides image into large number of tiles (1200x800)" do
      filename = "sample_1200x800"
      workers = 120
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {
          number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}
        }
      ).process_info
      puts result[:benchmarks].inspect
      expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "divides image into large number of tiles (1160x772)" do
      filename = "sample_1160x772"
      workers = 120

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      puts result[:benchmarks].inspect

      expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "resolves shape problem" do
      filename = "sample_20x52"
      workers = 2

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      color = @color_class.new(r: 251, g: 251, b: 251, a: 255)
      rgb_matcher = @png_not_matcher.new(color.to_rgb_raw)
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info

      expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "resolves shape problem (the tree leaf case)" do
      filename = "sample_30x46"
      workers = 3

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      color = @color_class.new(r: 251, g: 251, b: 251, a: 255)
      rgb_matcher = @png_not_matcher.new(color.to_rgb_raw)
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info

      expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "resolves shape problem (the bonsai tree case)" do
      filename = "sample_34x63"
      workers = 3

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      color = @color_class.new(r: 251, g: 251, b: 251, a: 255)
      rgb_matcher = @png_not_matcher.new(color.to_rgb_raw)
      TerminalTracker.new
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info

      expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "resolves shape problem (the bonsai full height tree case)" do
      filename = "sample_60x301"
      workers = 3
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      color = @color_class.new(r: 251, g: 251, b: 251, a: 255)
      rgb_matcher = @png_not_matcher.new(color.to_rgb_raw)
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info

      expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "works on small image many tiles" do
      filename = "sample_60x60"
      workers = 9

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info

      expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "resolves shape problem (the nested leaf case)" do
      filename = "sample_20x80"
      workers = 2

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info

      expect(result[:polygons]).to match_expected_polygons(filename, number_of_tiles: workers)
    end
  end
end
