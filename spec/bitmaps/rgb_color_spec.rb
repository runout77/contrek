RSpec.describe Contrek::Bitmaps::RgbColor, type: :class do
  describe "rgb color" do
    it "initializes rgb color struct" do
      rgba = Contrek::Bitmaps::RgbColor.new(r: 241, g: 156, b: 156)
      expect(rgba.raw).to eq 4053572863
    end
  end
end
