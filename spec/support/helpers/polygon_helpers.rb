# frozen_string_literal: true

module PolygonHelpers
  def bitmap_from(filename)
    Contrek::Bitmaps::PngBitmap.new("./spec/files/images/#{filename}")
  end
end

RSpec.configure do |config|
  config.include PolygonHelpers
end
