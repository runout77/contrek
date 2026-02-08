RSpec.shared_examples "multiprocessing" do
  describe "various multithreading cases" do
    it "works with 8 thread and 8 tiles" do
      filename = "sample_1200x800"
      tiles = 8
      workers = 8
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      result = @polygon_finder_class.new(
        number_of_threads: workers,
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: tiles, versus: :o, compress: {uniq: true}}
      ).process_info
      expect(result.metadata[:groups]).to eq 535
    end

    it "works with 2 thread and 2 tiles" do
      skip unless @polygon_finder_class == Contrek::Cpp::CPPConcurrentFinder
      filename = "sample_1024x1024d"
      tiles = 2
      workers = 2
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(
        number_of_threads: workers,
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: tiles, versus: :o}
      )
      result = polygonfinder.process_info
      puts result.metadata[:benchmarks].inspect
      expect(result.points).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
    end

    it "divides image into 4 tiles (2048x2048)" do
      filename = "graphs_2048x2048"
      workers = 4
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, compress: {uniq: true, linear: true}}
      )
      result = polygonfinder.process_info
      puts result.metadata[:benchmarks].inspect
      expect(result.points).to match_expected_polygons(filename, number_of_tiles: workers)
    end
  end
end
