module Map
  class MercatorProjection
    MERCATOR_RANGE = 256

    class LatLng
      attr_reader :lat, :lng
      def initialize(lat:, lng:)
        @lat = lat
        @lng = lng
      end
    end

    class Point
      attr_accessor :x, :y
      def initialize(x: 0, y: 0)
        @x = x
        @y = y
      end
    end

    def initialize
      @pixel_origin = Point.new(x: MERCATOR_RANGE / 2, y: MERCATOR_RANGE / 2)
      @pixels_per_lon_degree = MERCATOR_RANGE.to_f / 360
      @pixels_per_lon_radian = MERCATOR_RANGE.to_f / (2 * Math::PI)
    end

    def self.get_corners(center, zoom, map_width, map_height)
      scale = 2**zoom
      proj = Map::MercatorProjection.new
      center_px = proj.from_lat_lng_to_point(lat_lng: center)
      sw_point = Point.new(x: center_px.x - ((map_width / 2).to_f / scale), y: center_px.y + ((map_height / 2).to_f / scale))
      sw_lat_lon = proj.from_point_to_lat_lng(sw_point)
      ne_point = Point.new(x: center_px.x + ((map_width / 2).to_f / scale), y: center_px.y - ((map_height / 2).to_f / scale))
      ne_lat_lon = proj.from_point_to_lat_lng(ne_point)
      {
        N: ne_lat_lon.lat,
        E: ne_lat_lon.lng,
        S: sw_lat_lon.lat,
        W: sw_lat_lon.lng
      }
    end

    def from_lat_lng_to_point(lat_lng:, opt_point: nil)
      point = opt_point.nil? ? Point.new(x: 0, y: 0) : opt_point
      origin = @pixel_origin
      point.x = origin.x + (lat_lng.lng * @pixels_per_lon_degree)
      siny = bound(Math.sin(degreesToRadians(lat_lng.lat)), -0.9999, 0.9999)
      point.y = origin.y + (0.5 * Math.log((1 + siny) / (1 - siny)) * -@pixels_per_lon_radian)
      point
    end

    def from_point_to_lat_lng(point)
      origin = @pixel_origin
      lng = (point.x - origin.x) / @pixels_per_lon_degree
      lat_radians = (point.y - origin.y) / -@pixels_per_lon_radian
      lat = radiansToDegrees(2 * Math.atan(Math.exp(lat_radians)) - (Math::PI / 2))
      LatLng.new(lat: lat, lng: lng)
    end

    private

    def degreesToRadians(deg)
      deg * (Math::PI / 180)
    end

    def radiansToDegrees(rad)
      rad / (Math::PI / 180)
    end

    def bound(value, opt_min, opt_max)
      value = [value, opt_min].max if !opt_min.nil?
      value = [value, opt_max].min if !opt_max.nil?
      value
    end
  end
end
