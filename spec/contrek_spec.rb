RSpec.describe Contrek, type: :class do
  describe "shape finder" do
    it "trace contour" do
      result = Contrek.contour!(
        png_file_path: "./spec/files/images/labyrinth3.png",
        options: {
          class: "value_not_matcher",
          color: {r: 241, g: 156, b: 156, a: 255}
        }
      )
      expect(result[:polygons][0][:outer]).to eq([{x: 0, y: 0}, {x: 0, y: 259}, {x: 259, y: 259}, {x: 259, y: 0}])
    end

    it "trace contour by ruby code" do
      result = Contrek.contour!(
        png_file_path: "./spec/files/images/labyrinth3.png",
        options: {
          native: false,
          class: "value_not_matcher",
          color: {r: 241, g: 156, b: 156, a: 255}
        }
      )
      expect(result[:polygons][0][:outer]).to eq([{x: 0, y: 0}, {x: 0, y: 259}, {x: 259, y: 259}, {x: 259, y: 0}])
    end
  end
end
