# frozen_string_literal: true

RSpec.shared_examples "heavy" do
  describe "simple cases" do
    it "scans poly 1160x772" do
      filename = "sample_1160x772"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(@png_not_matcher_color)
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      # puts result.metadata[:benchmarks].inspect
      expect(result.points).to match_expected_polygons(filename, number_of_tiles: 1)
    end
    it "scans poly 1200x800" do
      filename = "sample_1200x800"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      # puts result.metadata[:benchmarks].inspect
      expect(result.points).to match_expected_polygons(filename, number_of_tiles: 1)
    end
    it "scans poly 1200x1192" do
      filename = "sample_1200x1192"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}.png")
      rgb_matcher = @png_not_matcher.new(png_bitmap.rgb_value_at(0, 0))
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      # puts result.metadata[:benchmarks].inspect
      expect(result.points).to match_expected_polygons(filename, number_of_tiles: 1)
    end
  end
end
