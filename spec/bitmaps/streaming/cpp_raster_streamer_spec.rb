# frozen_string_literal: true

RSpec.describe Contrek::Bitmaps::Streaming::RasterStreamer, type: :class do
  before do
    @vertical_merger_class = Contrek::Cpp::CPPConcurrentVerticalMerger
    @geo_json_streaming_merger = Contrek::Cpp::CPPGeoJsonConcurrentStreamingMerger
    @value_not_matcher_class = CPPValueNotMatcher
    @ascii_bitmap_class = CPPBitMap
    @polygon_finder_class = CPPPolygonFinder
    @raster_streamer_class = CPPRasterStreamer
    @rgba_not_matcher_class = CPPRGBNotMatcher
    @ascii_source_class = CPPAsciiSource
    @png_source_class = CPPPngSource
    @tiff_source_class = CPPTiffSource
    @png_bitmap_class = CPPRawBitMap
    @color_class = Contrek::Bitmaps::RgbCppColor
    @streaming_file = Contrek::Cpp::CPPTempfile
  end
  include_examples "streaming"
end
