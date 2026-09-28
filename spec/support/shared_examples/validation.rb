RSpec.shared_examples "validation" do
  describe "validation", :validation do
    it "extracts very large amount of polygons" do
      file_path = ENV.fetch("FILE_PATH")
      stripe_height = Integer(ENV.fetch("STRIPE_HEIGHT"))
      compare_hash = ENV.fetch("COMPARE_HASH")

      streaming_file = Contrek::Cpp::CPPTempfile.new("output.svg")
      # streaming_file = CPPOfstream.new('output.svg')
      source = CPPPngSource.new(file_path)
      svg_streaming_merger = Contrek::Cpp::CPPSvgConcurrentStreamingMerger.new(
        stream_to: streaming_file,
        total_width: source.width,
        total_height: source.height
      )
      streamer = CPPRasterStreamer.new(source, stripe_height: stripe_height)
      white = Contrek::Bitmaps::RgbCppColor.new(r: 255, g: 255, b: 255, a: 255)
      matcher = CPPRGBNotMatcher.new(white.raw)
      buffer_bitmap = CPPRawBitMap.new(source.width, streamer.stripe_height)
      processed_rows = 0
      streamer.each(buffer_bitmap) do |bitmap, buffer_rows, buffer_size, rows_read|
        tile = CPPPolygonFinder.new(
          bitmap,
          matcher,
          nil,
          {processing_height: buffer_rows, versus: :o, bounds: true}
        ).process_info
        processed_rows += rows_read
        last = processed_rows == source.height
        svg_streaming_merger.add_tile(tile, last)
        puts processed_rows
      end
      result = svg_streaming_merger.process_info
      expect(result.metadata[:width]).to eq(source.width)
      expect(result.metadata[:height]).to eq(source.height)

      streaming_file.close
      stream_hash = Digest::SHA256.file(streaming_file.path).hexdigest
      puts "SHA256: #{stream_hash}"
      expect(stream_hash).to eq(compare_hash)
    end
  end
end
