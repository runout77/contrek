module PolygonHelpers
  def bitmap_from(filename)
    Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}")
  end
end

# Attiva l’helper nei test
RSpec.configure do |config|
  config.include PolygonHelpers
end
