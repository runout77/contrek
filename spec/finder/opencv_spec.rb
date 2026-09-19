# frozen_string_literal: true

RSpec.describe Contrek::Shared::OpencvConverter, type: :class do
  describe "Converts" do
    before do
      @conv = Contrek::Shared::OpencvConverter.new
      @bounds = {min_x: 0, max_x: 8, min_y: 0, max_y: 5}
      @metadata = {width: 8, height: 5}
    end

    it "converts case 0" do
      contour = [
        {x: 3, y: 1},
        {x: 2, y: 2},
        {x: 3, y: 3},
        {x: 4, y: 3},
        {x: 5, y: 2},
        {x: 4, y: 1}
      ]
      rect = {x: 2, y: 1, width: 4, height: 3}

      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)
      expect(sequence).to eq([{x: 3, y: 1}, {x: 3, y: 2}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 3, y: 3},
        {x: 3, y: 4}, {x: 4, y: 4}, {x: 5, y: 4}, {x: 5, y: 3},
        {x: 6, y: 3}, {x: 6, y: 2}, {x: 5, y: 2}, {x: 5, y: 1},
        {x: 4, y: 1}])
      expect(bounds).to eq({min_x: 2, max_x: 6, min_y: 1, max_y: 4})
    end

    it "converts case 1" do
      contour = [
        {x: 2, y: 1},
        {x: 2, y: 2},
        {x: 2, y: 3},
        {x: 2, y: 2}
      ]
      rect = {x: 2, y: 1, width: 1, height: 3}

      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)

      expect(sequence).to eq([{x: 2, y: 1}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 2, y: 4},
        {x: 3, y: 4}, {x: 3, y: 3}, {x: 3, y: 2}, {x: 3, y: 1}])
      expect(bounds).to eq({min_x: 2, max_x: 3, min_y: 1, max_y: 4})
    end

    it "converts case 2" do
      contour = [
        {x: 2, y: 1},
        {x: 3, y: 2},
        {x: 3, y: 3},
        {x: 3, y: 2},
        {x: 4, y: 1},
        {x: 3, y: 1}
      ]
      rect = {x: 2, y: 1, width: 3, height: 3}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)

      expect(sequence).to eq([{x: 2, y: 1}, {x: 2, y: 2}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 3, y: 4},
        {x: 4, y: 4}, {x: 4, y: 3}, {x: 4, y: 2}, {x: 5, y: 2},
        {x: 5, y: 1}, {x: 4, y: 1}, {x: 3, y: 1}])
      expect(bounds).to eq({min_x: 2, max_x: 5, min_y: 1, max_y: 4})
    end

    it "converts case 3" do
      contour = [
        {x: 3, y: 1},
        {x: 2, y: 2},
        {x: 3, y: 2},
        {x: 3, y: 3},
        {x: 3, y: 2},
        {x: 4, y: 2}
      ]
      rect = {x: 2, y: 1, width: 3, height: 3}

      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)

      expect(sequence).to eq([{x: 3, y: 1}, {x: 3, y: 2}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 4, y: 4}, {x: 4, y: 3}, {x: 5, y: 3}, {x: 5, y: 2}, {x: 4, y: 2}, {x: 4, y: 1}])
      expect(bounds).to eq({min_x: 2, max_x: 5, min_y: 1, max_y: 4})
    end

    it "converts case 4" do
      contour = [
        {x: 1, y: 0},
        {x: 0, y: 1},
        {x: 0, y: 2},
        {x: 1, y: 3},
        {x: 0, y: 4},
        {x: 0, y: 5},
        {x: 1, y: 6},
        {x: 0, y: 7},
        {x: 1, y: 8},
        {x: 1, y: 9},
        {x: 2, y: 9},
        {x: 1, y: 8},
        {x: 2, y: 7},
        {x: 1, y: 6},
        {x: 2, y: 5},
        {x: 2, y: 4},
        {x: 2, y: 3},
        {x: 2, y: 2},
        {x: 2, y: 1}
      ]
      rect = {x: 0, y: 0, width: 3, height: 10}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)

      expect(sequence).to eq([{x: 1, y: 0}, {x: 1, y: 1}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3},
        {x: 1, y: 3}, {x: 1, y: 4}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6},
        {x: 1, y: 6}, {x: 1, y: 7}, {x: 0, y: 7}, {x: 0, y: 8}, {x: 1, y: 8},
        {x: 1, y: 9}, {x: 1, y: 10}, {x: 2, y: 10}, {x: 3, y: 10}, {x: 3, y: 9},
        {x: 2, y: 9}, {x: 2, y: 8}, {x: 3, y: 8}, {x: 3, y: 7}, {x: 2, y: 7},
        {x: 2, y: 6}, {x: 3, y: 6}, {x: 3, y: 5}, {x: 3, y: 4}, {x: 3, y: 3},
        {x: 3, y: 2}, {x: 3, y: 1}, {x: 2, y: 1}, {x: 2, y: 0}])
      expect(bounds).to eq({min_x: 0, max_x: 3, min_y: 0, max_y: 10})
    end

    it "converts case 5" do
      contour = [
        {x: 1, y: 1},
        {x: 2, y: 1},
        {x: 3, y: 1},
        {x: 2, y: 1}
      ]
      rect = {x: 1, y: 1, width: 3, height: 1}

      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)

      expect(sequence).to eq([{x: 1, y: 1}, {x: 1, y: 2}, {x: 2, y: 2}, {x: 3, y: 2}, {x: 4, y: 2}, {x: 4, y: 1}, {x: 3, y: 1}, {x: 2, y: 1}])
      expect(bounds).to eq({min_x: 1, max_x: 4, min_y: 1, max_y: 2})
    end

    it "converts case 6" do
      contour = [
        {x: 1, y: 1},
        {x: 1, y: 2},
        {x: 1, y: 3},
        {x: 2, y: 3},
        {x: 3, y: 3},
        {x: 2, y: 3},
        {x: 1, y: 2}
      ]
      rect = {x: 1, y: 1, width: 3, height: 3}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)

      expect(sequence).to eq([{x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 2, y: 4}, {x: 3, y: 4}, {x: 4, y: 4}, {x: 4, y: 3}, {x: 3, y: 3}, {x: 2, y: 3}, {x: 2, y: 2}, {x: 2, y: 1}])
      expect(bounds).to eq({min_x: 1, max_x: 4, min_y: 1, max_y: 4})
    end

    it "converts case 7" do
      contour = [
        {x: 1, y: 1},
        {x: 2, y: 2},
        {x: 3, y: 3},
        {x: 4, y: 3},
        {x: 3, y: 2},
        {x: 2, y: 1}
      ]
      rect = {x: 1, y: 1, width: 4, height: 3}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)
      expect(sequence).to eq([{x: 1, y: 1}, {x: 1, y: 2}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 4, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 4, y: 3}, {x: 4, y: 2}, {x: 3, y: 2}, {x: 3, y: 1}, {x: 2, y: 1}])
      expect(bounds).to eq({min_x: 1, max_x: 5, min_y: 1, max_y: 4})
    end

    it "converts case 8" do
      contour = [
        {x: 1, y: 1},
        {x: 2, y: 2},
        {x: 1, y: 3},
        {x: 2, y: 2},
        {x: 3, y: 3},
        {x: 2, y: 2},
        {x: 3, y: 1},
        {x: 2, y: 2}
      ]
      rect = {x: 1, y: 1, width: 3, height: 3}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)

      expect(sequence).to eq([{x: 1, y: 1}, {x: 1, y: 2}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 2, y: 4}, {x: 2, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 4, y: 4}, {x: 4, y: 3}, {x: 3, y: 3}, {x: 3, y: 2}, {x: 4, y: 2}, {x: 4, y: 1}, {x: 3, y: 1}, {x: 3, y: 2}, {x: 2, y: 2}, {x: 2, y: 1}])
      expect(bounds).to eq({min_x: 1, max_x: 4, min_y: 1, max_y: 4})
    end

    it "converts case 9" do
      contour = [
        {x: 3, y: 0},
        {x: 2, y: 1},
        {x: 1, y: 2},
        {x: 0, y: 2},
        {x: 1, y: 3},
        {x: 2, y: 4},
        {x: 3, y: 5},
        {x: 3, y: 4},
        {x: 4, y: 3},
        {x: 5, y: 3},
        {x: 4, y: 3},
        {x: 3, y: 2},
        {x: 4, y: 1}
      ]
      rect = {x: 0, y: 0, width: 6, height: 6}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)
      expect(sequence).to eq([{x: 3, y: 0}, {x: 3, y: 1}, {x: 2, y: 1}, {x: 2, y: 2}, {x: 1, y: 2}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 2, y: 4}, {x: 2, y: 5}, {x: 3, y: 5}, {x: 3, y: 6}, {x: 4, y: 6}, {x: 4, y: 5}, {x: 4, y: 4}, {x: 5, y: 4}, {x: 6, y: 4}, {x: 6, y: 3}, {x: 5, y: 3}, {x: 4, y: 3}, {x: 4, y: 2}, {x: 5, y: 2}, {x: 5, y: 1}, {x: 4, y: 1}, {x: 4, y: 0}])
      expect(bounds).to eq({min_x: 0, max_x: 6, min_y: 0, max_y: 6})
    end

    it "converts case 10" do
      contour = [
        {x: 0, y: 0},
        {x: 0, y: 1},
        {x: 0, y: 2},
        {x: 0, y: 3},
        {x: 0, y: 4},
        {x: 0, y: 5},
        {x: 0, y: 6},
        {x: 0, y: 7},
        {x: 1, y: 7},
        {x: 2, y: 7},
        {x: 3, y: 7},
        {x: 3, y: 6},
        {x: 4, y: 5},
        {x: 5, y: 6},
        {x: 6, y: 6},
        {x: 6, y: 5},
        {x: 7, y: 4},
        {x: 8, y: 4},
        {x: 9, y: 4},
        {x: 8, y: 4},
        {x: 7, y: 4},
        {x: 6, y: 3},
        {x: 5, y: 2},
        {x: 4, y: 3},
        {x: 4, y: 4},
        {x: 3, y: 5},
        {x: 2, y: 6},
        {x: 1, y: 5},
        {x: 1, y: 4},
        {x: 2, y: 3},
        {x: 2, y: 2},
        {x: 2, y: 1},
        {x: 1, y: 0}
      ]

      rect = {x: 0, y: 0, width: 10, height: 8}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)
      expect(sequence).to eq([{x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6}, {x: 0, y: 7}, {x: 0, y: 8}, {x: 1, y: 8}, {x: 2, y: 8}, {x: 3, y: 8}, {x: 4, y: 8}, {x: 4, y: 7}, {x: 4, y: 6}, {x: 5, y: 6}, {x: 5, y: 7}, {x: 6, y: 7}, {x: 7, y: 7}, {x: 7, y: 6}, {x: 7, y: 5}, {x: 8, y: 5}, {x: 9, y: 5}, {x: 10, y: 5}, {x: 10, y: 4}, {x: 9, y: 4}, {x: 8, y: 4}, {x: 7, y: 4}, {x: 7, y: 3}, {x: 6, y: 3}, {x: 6, y: 2}, {x: 5, y: 2}, {x: 5, y: 3}, {x: 4, y: 3}, {x: 4, y: 4}, {x: 4, y: 5}, {x: 3, y: 5}, {x: 3, y: 6}, {x: 2, y: 6}, {x: 2, y: 5}, {x: 2, y: 4}, {x: 3, y: 4}, {x: 3, y: 3}, {x: 3, y: 2}, {x: 3, y: 1}, {x: 2, y: 1}, {x: 2, y: 0}, {x: 1, y: 0}])
      expect(bounds).to eq({min_x: 0, max_x: 10, min_y: 0, max_y: 8})
    end

    it "converts case 11" do
      contour = [
        {x: 0, y: 0},
        {x: 1, y: 1},
        {x: 0, y: 2},
        {x: 0, y: 3},
        {x: 1, y: 3},
        {x: 1, y: 2},
        {x: 1, y: 1}
      ]
      rect = {x: 0, y: 0, width: 2, height: 4}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)
      expect(sequence).to eq([{x: 0, y: 0}, {x: 0, y: 1}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 1, y: 4}, {x: 2, y: 4}, {x: 2, y: 3}, {x: 2, y: 2}, {x: 2, y: 1}, {x: 1, y: 1}, {x: 1, y: 0}])
      expect(bounds).to eq({min_x: 0, max_x: 2, min_y: 0, max_y: 4})
    end

    it "converts case 12" do
      contour = [
        {x: 0, y: 0},
        {x: 1, y: 1}
      ]

      rect = {x: 0, y: 0, width: 2, height: 2}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)
      expect(sequence).to eq([{x: 0, y: 0}, {x: 0, y: 1}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 2, y: 2}, {x: 2, y: 1}, {x: 1, y: 1}, {x: 1, y: 0}])
      expect(bounds).to eq({min_x: 0, max_x: 2, min_y: 0, max_y: 2})
    end

    it "converts case 13" do
      contour = [
        {x: 0, y: 0},
        {x: 1, y: 1},
        {x: 2, y: 1},
        {x: 1, y: 1},
        {x: 1, y: 2},
        {x: 0, y: 1}
      ]
      rect = {x: 0, y: 0, width: 3, height: 3}
      sequence = @conv.contour_to_cell_boundary(contour, rect)
      bounds = @conv.rect_to_bounds(rect)

      result = Contrek::Finder::Result.new
      polygons = [{
        outer: sequence, inner: [],
        bounds: bounds
      }]
      result.polygons = polygons
      result.metadata = {width: 8, height: 5}
      expect(sequence).to eq([{x: 0, y: 0}, {x: 0, y: 1}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 2, y: 3},
        {x: 2, y: 2}, {x: 3, y: 2}, {x: 3, y: 1}, {x: 2, y: 1}, {x: 1, y: 1}, {x: 1, y: 0}])
      expect(bounds).to eq({min_x: 0, max_x: 3, min_y: 0, max_y: 3})
    end

    it "merge stripes coming from opencv" do
      converter = Contrek::Shared::OpencvConverter.new
      step_finder = Contrek::Concurrent::VerticalMerger.new(options: {unsafe_mode: true})
      0.upto(3) do |n|
        opencv_coords = JSON.parse(File.read("./spec/files/coordinates/opencv/opencv_stripe_#{n}.json"), symbolize_names: true)
        stripe_width = opencv_coords[:width]
        stripe_height = opencv_coords[:height]
        opencv_polygons = opencv_coords[:polygons].map do |cvpoly|
          {outer: converter.contour_to_cell_boundary(
            cvpoly[:outer][:points],
            cvpoly[:outer][:rect]
          ),
           inner: cvpoly[:inner].map { |p| converter.contour_to_cell_boundary(p[:points], p[:rect]) },
           bounds: converter.rect_to_bounds(cvpoly[:outer][:rect])}
        end
        result = Contrek::Finder::Result.new
        result.polygons = opencv_polygons
        result.sort_polygons!
        result.metadata = {width: stripe_width, height: stripe_height, versus: :a}
        step_finder.add_tile(result)
      end
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(1024)
      expect(result.metadata[:height]).to eq(1024)
      expect(result.points).to match_expected_json
    end
  end
end
