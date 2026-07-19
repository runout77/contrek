# frozen_string_literal: true

RSpec.describe CPPPolygonFinder, type: :class do
  describe "CPPPolygonFinder on image" do
    it "read png from iostring" do
      png_bitmap = CPPRemotePngBitMap.new("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg==")
      expect(png_bitmap.w).to eq(1)
      expect(png_bitmap.h).to eq(1)
    end
  end
end
