RSpec.shared_examples "generic" do
  describe "generic" do
    it "pass bounds option" do
      chunk = "                " \
              "     XXXXXXX    " \
              "     XXXXXXX    " \
              "     XXXXXXX    " \
              "     XXXXXXX    " \
              "     XXXXXXX    " \
              "                "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, bounds: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {bounds: {min_x: 5, max_x: 11, min_y: 1, max_y: 5},
         outer: [{x: 7, y: 1}, {x: 11, y: 1}, {x: 11, y: 5}, {x: 7, y: 5}, {x: 5, y: 5}, {x: 5, y: 1}],
         inner: []}
      ])
    end
  end
end
