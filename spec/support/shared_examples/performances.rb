# frozen_string_literal: true

RSpec.shared_examples "performances" do
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
        options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
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
        options: {number_of_tiles: workers, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
    end
    expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [2, 2], [2, 19], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [19, 1], [19, 1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [2, 51], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [34, 0], [-1, -1], [-1, -1], [-1, -1], [40, 0], [-1, -1], [-1, -1], [-1, -1], [13, 3], [13, 4], [13, 5], [13, 15], [-1, -1], [16, 29], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [19, 1], [19, 41], [19, 41], [19, 41], [19, 1], [19, 1], [19, 1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [58, 13], [58, 11], [58, 20], [-1, -1], [19, 7], [19, 25], [19, 25], [19, 1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [19, 1], [19, 1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [110, 7], [-1, -1], [-1, -1], [82, 11], [82, 13], [-1, -1], [82, 56], [-1, -1], [-1, -1], [58, 22], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [94, 0], [-1, -1], [103, 85], [103, 105], [103, 52], [-1, -1], [-1, -1], [137, 0], [-1, -1], [-1, -1], [140, 2], [110, 34], [110, 34], [110, 103], [110, 79], [110, 29], [110, 79], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [152, 16], [-1, -1], [-1, -1], [-1, -1], [129, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [163, 17], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [172, 6], [172, 6], [172, 6], [172, 6], [172, 77], [172, 5], [-1, -1], [139, 3], [-1, -1], [181, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [188, 2], [149, 25], [149, 20], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [153, 18], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [153, 50], [163, 21], [153, 110], [-1, -1], [-1, -1], [172, 7], [-1, -1], [172, 10], [-1, -1], [213, 33], [183, 9], [-1, -1], [-1, -1], [195, 39], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [153, 183], [-1, -1], [-1, -1], [153, 110], [-1, -1], [172, 49], [172, 53], [-1, -1], [-1, -1], [-1, -1], [232, 0], [-1, -1], [-1, -1], [-1, -1], [-1, -1], [221, 1]])
    expect(result.points).to match_expected_polygons(filename, number_of_tiles: workers)
    # verify_treemap(result)
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
        options: {number_of_tiles: workers, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
    end
    puts result.metadata[:benchmarks].inspect
    expect(result.to_svg).to match_expected_svg(filename, number_of_tiles: workers)
  end
end
