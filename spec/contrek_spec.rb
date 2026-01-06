RSpec.describe Contrek, type: :class do
  describe "shape finder" do
    it "trace contour" do
      result = Contrek.contour!(
        png_file_path: "./spec/files/images/labyrinth3.png",
        options: {
          class: "value_not_matcher",
          color: {r: 241, g: 156, b: 156, a: 255},
          finder: {compress: {uniq: true, linear: true}}
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
          color: {r: 241, g: 156, b: 156, a: 255},
          finder: {compress: {uniq: true, linear: true}}
        }
      )
      expect(result[:polygons][0][:outer]).to eq([{x: 0, y: 0}, {x: 0, y: 259}, {x: 259, y: 259}, {x: 259, y: 0}])
    end

    it "trace contour by ruby code clockwise" do
      result = Contrek.contour!(
        png_file_path: "./spec/files/images/rectangle_8x8.png",
        options: {
          native: false,
          class: "value_not_matcher",
          color: {r: 255, g: 255, b: 255, a: 255},
          finder: {versus: :o}
        }
      )
      expect(result[:polygons][0][:outer]).to eq([{x: 6, y: 1}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 6, y: 4}, {x: 6, y: 5}, {x: 6, y: 6}, {x: 1, y: 6}, {x: 1, y: 5}, {x: 1, y: 4}, {x: 1, y: 3}, {x: 1, y: 2}, {x: 1, y: 1}])
    end

    it "trace contour by multithread ruby code" do
      result = Contrek.contour!(
        png_file_path: "./spec/files/images/rectangle_8x8.png",
        options: {
          number_of_threads: 2,
          native: false,
          class: "value_not_matcher",
          color: {r: 255, g: 255, b: 255, a: 255},
          finder: {number_of_tiles: 2, compress: {uniq: true, linear: true}}
        }
      )
      expect(result[:polygons]).to eq([{
        outer: [{x: 1, y: 1}, {x: 1, y: 6}, {x: 3, y: 6}, {x: 6, y: 6}, {x: 6, y: 1}, {x: 3, y: 1}],
        inner: [[{x: 1, y: 5}, {x: 1, y: 2}, {x: 6, y: 2}, {x: 6, y: 5}]]
      }])
    end

    it "trace contour by multithread native code" do
      result = Contrek.contour!(
        png_file_path: "./spec/files/images/rectangle_8x8.png",
        options: {
          number_of_threads: 2,
          class: "value_not_matcher",
          color: {r: 255, g: 255, b: 255, a: 255},
          finder: {number_of_tiles: 2, compress: {uniq: true, linear: true}}
        }
      )
      expect(result[:polygons]).to eq([{
        outer: [{x: 1, y: 1}, {x: 1, y: 6}, {x: 3, y: 6}, {x: 6, y: 6}, {x: 6, y: 1}, {x: 3, y: 1}],
        inner: [[{x: 1, y: 5}, {x: 1, y: 2}, {x: 6, y: 2}, {x: 6, y: 5}]]
      }])
    end
  end
end
