require "contrek/version"
require "contrek/bitmaps/painting"
require "contrek/bitmaps/bitmap"
require "contrek/bitmaps/chunky_bitmap"
require "contrek/bitmaps/png_bitmap"
require "contrek/bitmaps/rgb_color"
require "contrek/finder/list"
require "contrek/finder/list_entry"
require "contrek/finder/listable"
require "contrek/finder/lists"
require "contrek/finder/node"
require "contrek/finder/node_cluster"
require "contrek/finder/polygon_finder"
require "contrek/map/mercator_projection"
require "contrek/matchers/matcher"
require "contrek/matchers/matcher_hsb"
require "contrek/matchers/value_not_matcher"
require "contrek/reducers/reducer"
require "contrek/reducers/linear_reducer"
require "contrek/reducers/uniq_reducer"
require "contrek/reducers/visvalingam_reducer"
require "cpp_polygon_finder"

module Contrek
  class << self
    def contour!(png_file_path:, options: {})
      default_options = {native: true, class: "value_not_matcher", color: {r: 0, g: 0, b: 0, a: 255}}.merge(options)
      default_options[:native] ? compute_cpp(png_file_path, default_options) : compute_ruby_pure(png_file_path, default_options)
    end

    private

    def compute_cpp(png_file_path, options)
      color = Bitmaps::RgbColor.new(**options[:color])
      png_bitmap = CPPPngBitMap.new(png_file_path)
      rgb_matcher_klass = (options[:class] == "value_not_matcher") ? CPPRGBNotMatcher : CPPRGBMatcher
      rgb_matcher = rgb_matcher_klass.new(color.to_rgb_raw)
      CPPPolygonFinder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, compress: {uniq: true, linear: true}}).process_info
    end

    def compute_ruby_pure(png_file_path, options)
      color = Bitmaps::RgbColor.new(**options[:color])
      png_bitmap = Bitmaps::PngBitmap.new(png_file_path)
      rgb_matcher = const_get("Contrek::Matchers::" + camelize("value_not_matcher")).new(color.raw)
      Contrek::Finder::PolygonFinder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, compress: {uniq: true, linear: true}}).process_info
    end

    def camelize(str)
      str.split("_").map { |e| e.capitalize }.join
    end
  end
end
