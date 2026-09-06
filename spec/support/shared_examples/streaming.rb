# frozen_string_literal: true

RSpec.shared_examples "streaming" do
  describe "streaming" do
    before do
      chunk = "00000000        " \
              "00000000        " \
              "00    00        " \
              "00000000  000000" \
              "00000000  000000" \
              "          00  00" \
              "          00  00" \
              "0000000   00  00" \
              "0000000   000000" \
              "00   00   000000" \
              "00   00         " \
              "00   00  0000000" \
              "00   00  0000000" \
              "00   00  00   00" \
              "00   00  00   00" \
              "00   00  0000000" \
              "00   00  0000000" \
              "00   00         " \
              "00   00         " \
              "00   00         " \
              "00   00         " \
              "0000000         " \
              "0000000         "
      @finder = @vertical_merger_class.new(options: {compress: {uniq: true, linear: true}})
      @matcher = @value_not_matcher_class.new(" ")
      @image = @ascii_bitmap_class.new(chunk, 16)
    end

    it "streams by three parts" do
      source = @ascii_source_class.new(@image)
      streamer = @raster_streamer_class.new(source, stripe_height: 10)
      buffer_bitmap = @ascii_bitmap_class.new(" " * streamer.stripe_height * 16, 16)

      streamer.each(buffer_bitmap) do |bitmap, buffer_rows, buffer_size|
        tile = @polygon_finder_class.new(bitmap,
          @matcher,
          nil,
          {processing_height: buffer_rows, versus: :o, bounds: true}).process_info
        @finder.add_tile(tile)
      end
      result = @finder.process_info
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(23)
      expect(result.points).to match_expected_json
    end

    it "streams by only one part" do
      source = @ascii_source_class.new(@image)
      streamer = @raster_streamer_class.new(source, stripe_height: 23)
      buffer_bitmap = @ascii_bitmap_class.new(" " * streamer.stripe_height * 16, 16)

      streamer.each(buffer_bitmap) do |bitmap, buffer_rows, buffer_size|
        tile = @polygon_finder_class.new(bitmap,
          @matcher,
          nil,
          {processing_height: buffer_rows, versus: :o, bounds: true}).process_info
        @finder.add_tile(tile)
      end
      result = @finder.process_info
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(23)
      expect(result.points).to match_expected_json
    end

    it "streams by multiple parts argb" do
      source = @png_source_class.new("./spec/files/images/labyrinth2.png")
      streamer = @raster_streamer_class.new(source, stripe_height: 20)
      white = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      matcher = @rgba_not_matcher_class.new(white.raw)
      buffer_bitmap = @png_bitmap_class.new(source.width, streamer.stripe_height)

      streamer.each(buffer_bitmap) do |bitmap, buffer_rows, buffer_size|
        tile = @polygon_finder_class.new(
          bitmap,
          matcher,
          nil,
          {processing_height: buffer_rows, versus: :o, bounds: true}
        ).process_info
        @finder.add_tile(tile)
      end
      result = @finder.process_info
      expect(result.metadata[:width]).to eq(130)
      expect(result.metadata[:height]).to eq(130)
      expect(result.points).to match_expected_json
    end
  end
end
