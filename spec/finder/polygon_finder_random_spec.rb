RSpec.describe Contrek::Finder::PolygonFinder, type: :class do
  before do
    @rows = 10
    @cols = 16
    @matcher = Contrek::Matchers::ValueNotMatcher.new("0")
  end

  describe "random test" do
    it "executes scans by random data" do
      repeat = 50
      repeat.times do |n|
        chunk = Array.new(@cols * @rows) { rand(0..5).to_s }.join
        bitmap = Contrek::Bitmaps::ChunkyBitmap.new(chunk, @cols)
        begin
          result = Timeout.timeout(10) do
            Contrek::Finder::PolygonFinder.new(bitmap,
              @matcher,
              nil,
              {versus: "a", compress: {linear: true, visvalingam: {tolerance: 1}}}).process_info
          end
        rescue => e
          puts chunk.inspect
          bitmap.to_terminal
          raise e
        else
          expect(result[:named_sequence]).not_to be(nil)
          expect(result[:groups]).not_to eq(0)
          expect(result[:polygons]).not_to be_empty
        end
      end
    end

    it "executes scans by random samples" do
      500.times do |n|
        versus = ["a", "o"].sample
        gen = Contrek::Bitmaps::SampleGenerator.new(rows: @rows, cols: @cols)
        gen.generate_blob_islands(count: 5,
          min_radius: 2,
          max_radius: 4,
          noise: 0.85)
        bitmap = Contrek::Bitmaps::ChunkyBitmap.new(gen.to_chunk, @cols)
        begin
          result = Timeout.timeout(10) do
            Contrek::Finder::PolygonFinder.new(bitmap,
              @matcher,
              nil,
              {versus: versus, compress: {linear: true, visvalingam: {tolerance: 1}}}).process_info
          end
        rescue => e
          puts gen.to_chunk.inspect
          bitmap.to_terminal
          raise e
        else
          expect(result[:named_sequence]).not_to be(nil)
          expect(result[:groups]).not_to eq(0)
          expect(result[:polygons]).not_to be_empty
        end
      end
    end
  end
end
