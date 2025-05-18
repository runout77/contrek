RSpec.describe Map::MercatorProjection, type: :class do
  describe "center test" do
    it "verifies constants" do
      center_lat = 49.141404
      center_lon = -121.960988
      zoom = 10
      map_width = 640
      map_height = 640
      center_point = Map::MercatorProjection::LatLng.new(lat: center_lat, lng: center_lon)
      corners = Map::MercatorProjection.get_corners(center_point, zoom, map_width, map_height)

      expect(corners).to eq({N: 49.428058350329835,
                               E: -121.52153487499999,
                               S: 48.85308195993289,
                               W: -122.40044112499999})
    end
  end
end
