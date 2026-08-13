# frozen_string_literal: true

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
      expect(result.metadata[:groups]).to eq 598
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
        options: {number_of_tiles: tiles, versus: :o, compress: {raster: true}}
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
        options: {number_of_tiles: workers, versus: :a, compress: {raster: true}}
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
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [0, 5], [-1, -1], [0, 7], [0, 18], [0, 68], [0, 68], [-1, -1], [0, 7], [-1, -1], [0, 43], [0, 43], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [0, 7], [0, 43], [0, 7], [0, 7], [-1, -1], [-1, -1], [0, 7], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [0, 7], [0, 7], [35, 27], [0, 7], [-1, -1], [32, 14], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [32, 15], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [32, 8], [-1, -1], [64, 98], [-1, -1], [64, 89], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [75, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [84, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [77, 7], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [77, 29], [-1, -1], [80, 10], [80, 10], [80, 14], [80, 15], [99, 3], [99, 5], [80, 4], [-1, -1], [-1, -1], [99, 78], [-1, -1], [99, 93], [-1, -1], [-1, -1], [113, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [120, 0], [-1, -1], [-1, -1], [120, 18], [120, 18], [120, 14], [120, 16], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [139, 31], [140, 17], [137, 16], [137, 16], [139, 160], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [156, 0], [-1, -1], [-1, -1], [19, 0], [-1, -1], [-1, -1], [-1, -1], [139, 58], [139, 58], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [171, 3], [171, 19], [-1, -1], [139, 55], [139, 55], [-1, -1], [177, 0], [177, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [169, 3], [35, 106], [35, 126], [-1, -1], [169, 33], [169, 33], [169, 33], [169, 33], [169, 51], [169, 18], [-1, -1], [35, 54], [169, 35], [-1, -1], [169, 2], [-1, -1], [-1, -1], [-1, -1], [204, 0], [169, 10], [169, 10], [-1, -1], [-1, -1], [210, 2], [209, 0], [-1, -1], [169, 37], [-1, -1], [213, 5], [77, 34], [-1, -1], [198, 4], [77, 34], [77, 34], [-1, -1], [-1, -1], [77, 92], [-1, -1], [223, 9], [-1, -1], [77, 69], [227, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [77, 68], [77, 29], [77, 68], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [240, 2], [-1, -1], [-1, -1], [218, 41], [-1, -1], [-1, -1], [-1, -1], [247, 25], [-1, -1], [253, 0], [-1, -1], [247, 4], [-1, -1]])
      expect(result.points).to match_expected_polygons(filename, number_of_tiles: workers)
    end
  end
end
