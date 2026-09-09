# frozen_string_literal: true

RSpec.describe Contrek::Bitmaps::Streaming::RasterStreamer, type: :class do
  before do
    @vertical_merger_class = Contrek::Concurrent::VerticalMerger
    @geo_json_streaming_merger = Contrek::Concurrent::GeoJsonStreamingMerger
    @value_not_matcher_class = Contrek::Matchers::ValueNotMatcher
    @ascii_bitmap_class = Contrek::Bitmaps::ChunkyBitmap
    @polygon_finder_class = Contrek::Finder::PolygonFinder
    @raster_streamer_class = Contrek::Bitmaps::Streaming::RasterStreamer
    @rgba_not_matcher_class = Contrek::Matchers::ValueNotMatcher
    @ascii_source_class = Contrek::Bitmaps::Streaming::Sources::Ascii
    @png_source_class = Contrek::Bitmaps::Streaming::Sources::Png
    @tiff_source_class = Contrek::Bitmaps::Streaming::Sources::Tiff
    @png_bitmap_class = Contrek::Bitmaps::RgbaBitmap
    @color_class = Contrek::Bitmaps::RgbColor
    @streaming_file = Tempfile
  end
  include_examples "streaming"
end
