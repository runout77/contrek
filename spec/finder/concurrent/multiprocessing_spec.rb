RSpec.describe Contrek::Concurrent::Finder, type: :class do
  it "works with 8 thread and 8 tiles" do
    filename = "sample_1200x800"
    workers = 8
    png_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}.png")
    rgb_matcher = Contrek::Matchers::ValueNotMatcher.new(png_bitmap.rgb_value_at(0, 0))
    polygonfinder = Contrek::Concurrent::Finder.new(
      number_of_threads: workers,
      bitmap: png_bitmap,
      matcher: rgb_matcher,
      options: {number_of_tiles: workers, versus: :o, compress: {uniq: true, linear: true}}
    )
    result = polygonfinder.process_info(png_bitmap)
    puts result[:benchmarks].inspect
    expect(polygonfinder.number_of_threads).to eq 8
  end

  it "massive 110 to 8 tiles both :o and :a versus" do
    skip
    filename = "sample_1200x800"
    workers = 110
    color = Contrek::Bitmaps::RgbColor.new(r: 251, g: 251, b: 251, a: 255)
    rgb_matcher = Contrek::Matchers::ValueNotMatcher.new(color.raw)
    versuses = [:a, :o]
    versuses.each do |versus|
      workers.downto(8) do |sw|
        png_bitmap = Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}.png")
        result = Contrek::Concurrent::Finder.new(
          bitmap: png_bitmap,
          matcher: rgb_matcher,
          options: {number_of_tiles: sw, versus: versus, compress: {uniq: true, linear: true}}
        ).process_info(png_bitmap)
        puts result[:benchmarks].inspect
        expect(result[:polygons]).to match_expected_polygons(filename,
          number_of_tiles: sw,
          additional_files_path: ["massive", versus.to_s])
      end
    end
  end
end
