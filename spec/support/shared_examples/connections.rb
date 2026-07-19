# frozen_string_literal: true

RSpec.shared_examples "connections" do
  describe "connections" do
    it "supports 8 connections" do
      chunk = " AA  BB         " \
              " AA  BB         " \
              "   CC           " \
              "   CC           " \
              " DD  EE         " \
              " DD  EE         "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {connectivity: 8}).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 1, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 1, y: 4}, {x: 1, y: 5}, {x: 1, y: 6}, {x: 3, y: 6}, {x: 3, y: 5}, {x: 3, y: 4}, {x: 5, y: 4}, {x: 5, y: 5}, {x: 5, y: 6}, {x: 7, y: 6}, {x: 7, y: 5}, {x: 7, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 5, y: 2}, {x: 7, y: 2}, {x: 7, y: 1}, {x: 7, y: 0}, {x: 5, y: 0}, {x: 5, y: 1}, {x: 5, y: 2}, {x: 3, y: 2}, {x: 3, y: 1}, {x: 3, y: 0}], inner: []}])

      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, connectivity: 8}).process_info
      expect(result.points).to eq([{outer: [{x: 3, y: 0}, {x: 3, y: 1}, {x: 3, y: 2}, {x: 5, y: 2}, {x: 5, y: 1}, {x: 5, y: 0}, {x: 7, y: 0}, {x: 7, y: 1}, {x: 7, y: 2}, {x: 5, y: 2}, {x: 5, y: 3}, {x: 5, y: 4}, {x: 7, y: 4}, {x: 7, y: 5}, {x: 7, y: 6}, {x: 5, y: 6}, {x: 5, y: 5}, {x: 5, y: 4}, {x: 3, y: 4}, {x: 3, y: 5}, {x: 3, y: 6}, {x: 1, y: 6}, {x: 1, y: 5}, {x: 1, y: 4}, {x: 3, y: 4}, {x: 3, y: 3}, {x: 3, y: 2}, {x: 1, y: 2}, {x: 1, y: 1}, {x: 1, y: 0}], inner: []}])
    end
  end
end
