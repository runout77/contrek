RSpec.shared_examples "connections" do
  describe "simple cases" do
    it "supports 8 connections" do
      chunk = " AA  BB         " \
              " AA  BB         " \
              "   CC           " \
              "   CC           " \
              " DD  EE         " \
              " DD  EE         "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {connectivity: 8}).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 1, y: 0}, {x: 1, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 1, y: 4}, {x: 1, y: 5}, {x: 2, y: 5}, {x: 2, y: 4}, {x: 5, y: 4}, {x: 5, y: 5}, {x: 6, y: 5}, {x: 6, y: 4}, {x: 4, y: 3}, {x: 4, y: 2}, {x: 6, y: 1}, {x: 6, y: 0}, {x: 5, y: 0}, {x: 5, y: 1}, {x: 2, y: 1}, {x: 2, y: 0}], inner: []}])
    end
  end
end
