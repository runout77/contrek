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

    it "streams evils sequence connectivity 8 and anticlockwise" do
      chunk =
        "                                " \
        "              00000000000000000 " \
        "A00000000     E               0 " \
        "a       0     0               0 " \
        "0       0     0               0 " \
        "000000000     0               0 " \
        "    0         0   X00000000   0 " \
        "  000000000   0   C   0   0   0 " \
        "  0       0   0   0   0   0   0 " \
        "  0       0   0   0   0   0   0 " \
        "  B       1   0   1   1   D   1 " \
        "  0       0   0   0   0   0   0 " \
        "  0       0   00000   0   00000 " \
        "  0       0           0         " \
        "  0       0000000000000         " \
        "  0       0                     " \
        "  0       0                     " \
        "  0       0                     " \
        "  000000000                     "
      # transposed version
      #   "  Aa00             " \
      #   "  0  0             " \
      #   "  0  0 000B00000000" \
      #   "  0  0 0          0" \
      #   "  0  000          0" \
      #   "  0  0 0          0" \
      #   "  0  0 0          0" \
      #   "  0  0 0          0" \
      #   "  0000 0          0" \
      #   "       0          0" \
      #   "       000100000000" \
      #   "              0    " \
      #   "              0    " \
      #   "              0    " \
      #   " 0E0000000000 0    " \
      #   " 0          0 0    " \
      #   " 0          0 0    " \
      #   " 0          0 0    " \
      #   " 0    XC00100 0    " \
      #   " 0    0       0    " \
      #   " 0    0       0    " \
      #   " 0    0       0    " \
      #   " 0    000010000    " \
      #   " 0    0            " \
      #   " 0    0            " \
      #   " 0    0            " \
      #   " 0    0000D00      " \
      #   " 0          0      " \
      #   " 0          0      " \
      #   " 0          0      " \
      #   " 000000000100      " \
      #   "                   "
      image = @ascii_bitmap_class.new(chunk, 32)
      source = @ascii_source_class.new(image)
      streamer = @raster_streamer_class.new(source, stripe_height: 10)
      buffer_bitmap = @ascii_bitmap_class.new(" " * streamer.stripe_height * 32, 32)
      streamer.each(buffer_bitmap) do |bitmap, buffer_rows, buffer_size|
        stream_result = @polygon_finder_class.new(bitmap,
          @matcher,
          nil,
          {connectivity: 8, processing_height: buffer_rows, versus: :a, bounds: true}).process_info
        @finder.add_tile(stream_result)
      end
      result = @finder.process_info
      expect(result.metadata[:width]).to eq(32)
      expect(result.metadata[:height]).to eq(19)
      expect(result.metadata[:versus]).to eq(:a)
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      # adds a pixel
      image.value_set(0, 1, "0")
      @finder = @vertical_merger_class.new(options: {compress: {uniq: true, linear: true}})
      source = @ascii_source_class.new(image)
      streamer = @raster_streamer_class.new(source, stripe_height: 10)
      buffer_bitmap = @ascii_bitmap_class.new(" " * streamer.stripe_height * 32, 32)
      streamer.each(buffer_bitmap) do |bitmap, buffer_rows, buffer_size|
        stream_result = @polygon_finder_class.new(bitmap,
          @matcher,
          nil,
          {connectivity: 8, processing_height: buffer_rows, versus: :o,
           bounds: true, compress: {uniq: true, linear: true}}).process_info
        @finder.add_tile(stream_result)
      end
      result = @finder.process_info
      expect(result.metadata[:width]).to eq(32)
      expect(result.metadata[:height]).to eq(19)
      expect(result.metadata[:versus]).to eq(:o)
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "streams by multiple parts argb connectivity 8" do
      source = @png_source_class.new("./spec/files/images/graphs_1024x1024.png")
      streamer = @raster_streamer_class.new(source, stripe_height: 200)
      white = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      matcher = @rgba_not_matcher_class.new(white.raw)
      buffer_bitmap = @png_bitmap_class.new(source.width, streamer.stripe_height)

      streamer.each(buffer_bitmap) do |bitmap, buffer_rows, buffer_size|
        tile = @polygon_finder_class.new(
          bitmap,
          matcher,
          nil,
          {connectivity: 8, processing_height: buffer_rows, versus: :a, bounds: true,
           compress: {uniq: true, linear: true}}
        ).process_info
        @finder.add_tile(tile)
      end
      result = @finder.process_info
      expect(result.metadata[:width]).to eq(1024)
      expect(result.metadata[:height]).to eq(1024)
      expect(result.points).to match_expected_json
    end

    it "streams by multiple parts geotiff" do
      source = @tiff_source_class.new("./spec/files/images/pania_della_croce_wgs84.tif", suppress_warnings: true)
      streamer = @raster_streamer_class.new(source, stripe_height: 20)
      white = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      matcher = @rgba_not_matcher_class.new(white.raw)
      buffer_bitmap = @png_bitmap_class.new(source.width, streamer.stripe_height)

      localization = source.geo_localization
      expect(localization[:crs]).to eq({authority: "EPSG", code: 4326})

      shared_stream = @streaming_file.new("output.geojson")

      v_merger_options = {geo_localization: localization, compress: {uniq: true, linear: true}}
      geo_finder = @geo_json_streaming_merger.new(
        options: v_merger_options,
        stream_to: shared_stream,
        pixel_val: 11
      )
      stripes_count = 0
      total_height = 0
      streamer.each(buffer_bitmap) do |bitmap, buffer_rows, buffer_size, rows_read|
        tile = @polygon_finder_class.new(
          bitmap,
          matcher,
          nil,
          {processing_height: buffer_rows, versus: :o, bounds: true, compress: {uniq: true}}
        ).process_info
        total_height += rows_read
        geo_finder.add_tile(tile, total_height == source.height)
        stripes_count += 1
      end
      result = geo_finder.process_info
      expect(result.metadata[:width]).to eq(64)
      expect(result.metadata[:height]).to eq(64)
      expect(result.points).to be_empty
      shared_stream.rewind

      expect(shared_stream.read).to match_expected_stream(
        "test_#{result.metadata[:width]}x#{result.metadata[:height]}_#{@geo_json_streaming_merger.name.gsub("::", "_").downcase}",
        extension: "geojson",
        number_of_tiles: stripes_count
      )
    end
  end
end
