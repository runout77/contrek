# frozen_string_literal: true

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
      expect(result.points[0][:outer]).to eq([{x: 0, y: 0}, {x: 0, y: 260}, {x: 260, y: 260}, {x: 260, y: 0}])
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
      expect(result.points[0][:outer]).to eq([{x: 0, y: 0}, {x: 0, y: 260}, {x: 260, y: 260}, {x: 260, y: 0}])
    end

    it "trace contour by ruby code clockwise" do
      result = Contrek.contour!(
        png_file_path: "./spec/files/images/rectangle_8x8.png",
        options: {
          native: false,
          class: "value_not_matcher",
          color: {r: 255, g: 255, b: 255, a: 255},
          finder: {versus: :o, compress: {linear: true}}
        }
      )
      expect(result.points[0][:outer]).to eq([{x: 7, y: 1}, {x: 7, y: 7}, {x: 1, y: 7}, {x: 1, y: 1}])
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
      expect(result.points).to eq([{inner: [[{x: 2, y: 6}, {x: 2, y: 2}, {x: 6, y: 2}, {x: 6, y: 6}]],
                                    outer: [{x: 1, y: 1}, {x: 1, y: 7}, {x: 7, y: 7}, {x: 7, y: 1}]}])
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
      expect(result.points).to eq([{inner: [[{x: 2, y: 6}, {x: 2, y: 2}, {x: 6, y: 2}, {x: 6, y: 6}]],
                                    outer: [{x: 1, y: 1}, {x: 1, y: 7}, {x: 7, y: 7}, {x: 7, y: 1}]}])
    end
  end
end
