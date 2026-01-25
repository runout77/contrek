RSpec.describe Contrek::Bitmaps::RgbCppColor, type: :class do
  describe "rgb color" do
    it "initializes rgb color struct (ABGR)" do
      rgba = Contrek::Bitmaps::RgbCppColor.new(r: 1, g: 2, b: 3, a: 4)
      expect(rgba.raw).to eq 67305985
    end

    it "initializes rgb color struct (RGBA)" do
      rgba = Contrek::Bitmaps::RgbColor.new(r: 1, g: 2, b: 3, a: 4)
      expect(rgba.raw).to eq 16909060
    end
  end
end
