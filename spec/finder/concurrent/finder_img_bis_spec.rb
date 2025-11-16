RSpec.describe Contrek::Concurrent::Finder, type: :class do
  it "divides image into large number of tiles (1200x800) clockwise" do
    filename = "sample_1200x800"
    workers = 120

    png_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}.png")
    color = Contrek::Bitmaps::RgbColor.new(r: 251, g: 251, b: 251, a: 255)
    rgb_matcher = Contrek::Matchers::ValueNotMatcher.new(color.raw)
    result = Contrek::Concurrent::Finder.new(
      bitmap: png_bitmap,
      matcher: rgb_matcher,
      options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
    ).process_info(png_bitmap)

    puts result[:benchmarks].inspect
    expect(result[:polygons]).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
  end

  it "divides image into large number of tiles (1160x772) clockwise" do
    filename = "sample_1160x772"
    workers = 120

    png_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}.png")
    png_not_matcher_color = 4294967295
    rgb_matcher = Contrek::Matchers::ValueNotMatcher.new(png_not_matcher_color)
    result = Contrek::Concurrent::Finder.new(
      bitmap: png_bitmap,
      matcher: rgb_matcher,
      options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
    ).process_info(png_bitmap)
    puts result[:benchmarks].inspect

    expect(result[:polygons]).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
  end

  it "divides image into large number of tiles (3000x3000) clockwise" do
    skip
    filename = "sample_3000x3000"
    workers = 300

    png_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}.png")
    rgb_matcher = Contrek::Matchers::ValueNotMatcher.new(png_bitmap.rgb_value_at(0, 0))
    result = Contrek::Concurrent::Finder.new(
      bitmap: png_bitmap,
      matcher: rgb_matcher,
      options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
    ).process_info(png_bitmap)
    puts result[:benchmarks].inspect

    expect(result[:polygons]).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
  end

  it "divides image into large number of tiles (1024x1024) clockwise" do
    skip
    filename = "sample_1024x1024"
    workers = 120

    png_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}.png")
    rgb_matcher = Contrek::Matchers::ValueNotMatcher.new(png_bitmap.rgb_value_at(0, 0))
    result = Contrek::Concurrent::Finder.new(
      bitmap: png_bitmap,
      matcher: rgb_matcher,
      options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
    ).process_info(png_bitmap)
    puts result[:benchmarks].inspect

    expect(result[:polygons]).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
  end

  it "divides spiral into large number of tiles (1024x1024) clockwise" do
    filename = "sample_1024x1024b"
    workers = 100

    png_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}.png")
    rgb_matcher = Contrek::Matchers::ValueNotMatcher.new(png_bitmap.rgb_value_at(0, 0))
    result = Contrek::Concurrent::Finder.new(
      bitmap: png_bitmap,
      matcher: rgb_matcher,
      options: {number_of_tiles: workers, versus: :o}
    ).process_info(png_bitmap)
    puts result[:benchmarks].inspect

    expect(result[:polygons]).to match_expected_polygons(filename + "_o", number_of_tiles: workers)
  end
end
