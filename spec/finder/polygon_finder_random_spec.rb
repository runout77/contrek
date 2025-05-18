RSpec.describe Contrek::Finder::PolygonFinder, type: :class do
  before do
    @matcher = Contrek::Matchers::ValueNotMatcher.new("0")
  end

  describe "random test" do
    it "executes scans by random data" do
      repeat = 50
      repeat.times do |n|
        chunk = Array.new(16 * 10) { rand(0..5).to_s }.join
        result = Contrek::Finder::PolygonFinder.new(Contrek::Bitmaps::ChunkyBitmap.new(chunk, 16),
          @matcher,
          nil,
          {versus: "a", compress: {linear: true, visvalingam: {tolerance: 1}}}).process_info

        expect(result[:named_sequence]).not_to be(nil)
        expect(result[:groups]).not_to eq(0)
        expect(result[:polygons]).not_to be_empty
      end
    end
  end
end
