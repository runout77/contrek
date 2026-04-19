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
      skip unless @polygon_finder_class == Contrek::Cpp::CPPConcurrentFinder
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

    it "divides image into 4 tiles (1024x1024) with treemap" do
      filename = "graphs_1024x1024"
      workers = 2
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(
        number_of_threads: workers,
        bitmap: png_bitmap,
        matcher: rgb_matcher,
        options: {number_of_tiles: workers, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      )
      result = polygonfinder.process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [0, 5], [-1, -1], [0, 7], [0, 68], [0, 68], [-1, -1], [0, 7], [-1, -1], [0, 43], [0, 43], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [0, 7], [0, 43], [0, 7], [0, 7], [-1, -1], [-1, -1], [0, 7], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [0, 7], [0, 7], [0, 7], [-1, -1], [30, 14], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [30, 15], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [30, 8], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [70, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [79, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [72, 7], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [75, 10], [75, 14], [75, 15], [93, 3], [93, 5], [75, 4], [-1, -1], [-1, -1], [93, 78], [-1, -1], [-1, -1], [104, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [111, 0], [-1, -1], [-1, -1], [111, 18], [111, 14], [111, 16], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [129, 31], [127, 16], [129, 160], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [144, 0], [-1, -1], [-1, -1], [18, 0], [-1, -1], [-1, -1], [-1, -1], [129, 58], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [158, 3], [158, 19], [-1, -1], [129, 55], [129, 55], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [156, 3], [33, 106], [33, 126], [-1, -1], [156, 33], [156, 33], [156, 33], [156, 33], [156, 51], [156, 18], [-1, -1], [33, 54], [156, 35], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [188, 0], [156, 10], [-1, -1], [-1, -1], [193, 2], [192, 0], [-1, -1], [156, 37], [-1, -1], [196, 5], [72, 34], [-1, -1], [183, 4], [72, 34], [-1, -1], [-1, -1], [72, 92], [-1, -1], [205, 9], [-1, -1], [209, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [72, 68], [72, 29], [72, 68], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [221, 2], [-1, -1], [-1, -1], [201, 41], [-1, -1], [-1, -1], [-1, -1], [228, 25], [-1, -1], [234, 0], [-1, -1], [228, 4], [-1, -1]])
      expect(result.points).to match_expected_polygons(filename, number_of_tiles: workers)
      puts result.metadata[:benchmarks].inspect
      # verify_treemap(result)
    end
  end
end
