# frozen_string_literal: true

RSpec.shared_examples "performances" do
  describe "performances" do
    it "scans large 3000x3000 image only one tile", :performance do
      filename = "sample_3000x3000"
      workers = 1

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      result = expect_performance do
        polygonfinder = @polygon_finder_class.new(
          bitmap: png_bitmap,
          matcher: @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0)),
          options: {number_of_tiles: workers, versus: :a}
        )
        polygonfinder.process_info
      end

      expect(result.points).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "divides image into large number of tiles (3000x3000) clockwise", :performance do
      filename = "sample_3000x3000"
      workers = 300

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = expect_performance do
        @polygon_finder_class.new(
          bitmap: png_bitmap,
          matcher: rgb_matcher,
          options: {number_of_tiles: workers, versus: :o}
        ).process_info
      end
      puts result.metadata[:benchmarks].inspect
      expect(result.points).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
    end

    it "divides image into 8 tiles (1024x1024)", :performance do
      filename = "graphs_1024x1024"
      workers = 8

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = expect_performance do
        @polygon_finder_class.new(
          bitmap: png_bitmap,
          matcher: rgb_matcher,
          options: {number_of_tiles: workers, versus: :a, treemap: true, compress: {linear: true}}
        ).process_info
      end
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [2, 2], [2, 19], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [19, 1], [19, 1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [2, 51], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [34, 0], [-1, -1], [-1, -1], [-1, -1], [40, 0], [-1, -1], [-1, -1], [-1, -1], [13, 3], [13, 3], [13, 4], [13, 5], [13, 15], [-1, -1], [-1, -1], [16, 29], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [19, 1], [19, 41], [19, 41], [19, 41], [19, 1], [19, 1], [19, 1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [31, 43], [31, 42], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [60, 13], [60, 13], [60, 11], [60, 20], [-1, -1], [19, 7], [19, 18], [19, 25], [19, 25], [19, 1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [19, 1], [19, 1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [110, 27], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [118, 7], [-1, -1], [-1, -1], [118, 29], [86, 11], [86, 13], [-1, -1], [86, 56], [-1, -1], [86, 22], [-1, -1], [60, 22], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [136, 17], [-1, -1], [-1, -1], [-1, -1], [100, 0], [-1, -1], [110, 85], [110, 105], [110, 52], [-1, -1], [-1, -1], [148, 0], [-1, -1], [-1, -1], [151, 2], [118, 34], [118, 34], [118, 34], [118, 103], [118, 80], [118, 79], [118, 29], [118, 79], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [166, 16], [166, 16], [-1, -1], [-1, -1], [-1, -1], [140, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [178, 21], [178, 17], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [188, 6], [188, 6], [188, 6], [188, 6], [188, 77], [188, 1], [188, 5], [-1, -1], [150, 3], [-1, -1], [198, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [205, 2], [163, 25], [163, 20], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [167, 18], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [167, 50], [167, 50], [167, 110], [-1, -1], [-1, -1], [188, 7], [-1, -1], [188, 10], [188, 10], [-1, -1], [230, 33], [200, 9], [-1, -1], [-1, -1], [211, 39], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [167, 183], [-1, -1], [-1, -1], [167, 110], [-1, -1], [244, 0], [244, 0], [188, 49], [188, 53], [-1, -1], [-1, -1], [-1, -1], [251, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [238, 1]])
      expect(result.points).to match_expected_polygons(filename, number_of_tiles: workers)
    end

    it "divides image into 8 tiles (10240x10240)", :performance do
      skip unless @polygon_finder_class == Contrek::Cpp::CPPConcurrentFinder
      filename = "sample_10240x10240"
      workers = 8

      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = expect_performance do
        @polygon_finder_class.new(
          bitmap: png_bitmap,
          matcher: rgb_matcher,
          options: {number_of_tiles: workers, versus: :a, connectivity: 8, compress: {douglas_peucker: true}}
        ).process_info
      end
      puts result.metadata[:benchmarks].inspect
      expect(result.to_svg).to match_expected_stream(filename, number_of_tiles: workers, extension: "svg")
    end
  end
end
