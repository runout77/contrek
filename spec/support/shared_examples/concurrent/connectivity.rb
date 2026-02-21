RSpec.shared_examples "connectivity" do
  describe "various cases" do
    it "connections 8 case 0" do
      #        ---------*----------
      chunk = "0000000000          " \
              "0000000000          " \
              "0000000000          " \
              "          0000000000" \
              "          0000000000" \
              "          0000000000"

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 2}, {x: 9, y: 2}, {x: 10, y: 3}, {x: 10, y: 5}, {x: 19, y: 5}, {x: 19, y: 3}, {x: 9, y: 2}, {x: 9, y: 0}], inner: []}])
    end

    it "connections 8 case 0 versus o" do
      #        ---------*----------
      chunk = "0000000000          " \
              "0000000000          " \
              "0000000000          " \
              "          0000000000" \
              "          0000000000" \
              "          0000000000"

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info

      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 9, y: 2}, {x: 19, y: 3}, {x: 19, y: 5}, {x: 10, y: 5}, {x: 10, y: 3}, {x: 9, y: 2}, {x: 0, y: 2}, {x: 0, y: 0}], inner: []}])
    end

    it "connections 8 case 2" do
      #        ---------*----------
      chunk = "000000000           " \
              "0000000000          " \
              "          0000000000" \
              "           000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 9, y: 1}, {x: 11, y: 3}, {x: 19, y: 3}, {x: 19, y: 2}, {x: 9, y: 1}, {x: 8, y: 0}], inner: []}])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 8, y: 0}, {x: 9, y: 1}, {x: 19, y: 2}, {x: 19, y: 3}, {x: 11, y: 3}, {x: 9, y: 1}, {x: 0, y: 1}, {x: 0, y: 0}], inner: []}])
    end

    it "connections 8 case 3" do
      #        ---------*----------
      chunk = "      000   000     " \
              "      000   000     " \
              "         000        " \
              "         000        " \
              "      000   000     " \
              "      000   000     "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 6, y: 0}, {x: 6, y: 1}, {x: 9, y: 2}, {x: 9, y: 3}, {x: 6, y: 4}, {x: 6, y: 5}, {x: 8, y: 5}, {x: 8, y: 4}, {x: 9, y: 3}, {x: 12, y: 4}, {x: 12, y: 5}, {x: 14, y: 5}, {x: 14, y: 4}, {x: 11, y: 3}, {x: 11, y: 2}, {x: 14, y: 1}, {x: 14, y: 0}, {x: 12, y: 0}, {x: 12, y: 1}, {x: 9, y: 2}, {x: 8, y: 1}, {x: 8, y: 0}], inner: []}])
    end

    it "connections 8 case 4" do
      #        ---------*----------
      chunk = "     000   000      " \
              "     000   000      " \
              "        000         " \
              "        000         " \
              "     000   000      " \
              "     000   000      "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 5, y: 0}, {x: 5, y: 1}, {x: 8, y: 2}, {x: 8, y: 3}, {x: 5, y: 4}, {x: 5, y: 5}, {x: 7, y: 5}, {x: 7, y: 4}, {x: 9, y: 3}, {x: 11, y: 4}, {x: 11, y: 5}, {x: 13, y: 5}, {x: 13, y: 4}, {x: 10, y: 3}, {x: 10, y: 2}, {x: 13, y: 1}, {x: 13, y: 0}, {x: 11, y: 0}, {x: 11, y: 1}, {x: 9, y: 2}, {x: 7, y: 1}, {x: 7, y: 0}], inner: []}])
    end

    it "connections 8 case 5" do
      #        ---------*----------
      chunk = "          000       " \
              "          000       " \
              "       000          " \
              "       000          " \
              "          000       " \
              "          000       "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 7, y: 2}, {x: 7, y: 3}, {x: 9, y: 3}, {x: 10, y: 4}, {x: 10, y: 5}, {x: 12, y: 5}, {x: 12, y: 4}, {x: 9, y: 3}, {x: 9, y: 2}, {x: 12, y: 1}, {x: 12, y: 0}, {x: 10, y: 0}, {x: 10, y: 1}, {x: 9, y: 2}], inner: []}])
    end

    it "connections 8 case 6" do
      #        ---------*----------
      chunk = "    000   000       " \
              "    000   000       " \
              "       000          " \
              "       000          " \
              "    000   000       " \
              "    000   000       "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 4, y: 0}, {x: 4, y: 1}, {x: 7, y: 2}, {x: 7, y: 3}, {x: 4, y: 4}, {x: 4, y: 5}, {x: 6, y: 5}, {x: 6, y: 4}, {x: 9, y: 3}, {x: 10, y: 4}, {x: 10, y: 5}, {x: 12, y: 5}, {x: 12, y: 4}, {x: 9, y: 3}, {x: 9, y: 2}, {x: 12, y: 1}, {x: 12, y: 0}, {x: 10, y: 0}, {x: 10, y: 1}, {x: 9, y: 2}, {x: 6, y: 1}, {x: 6, y: 0}], inner: []}])
    end

    it "connections 8 case 7" do
      #        ---------*----------
      chunk = "   000   000        " \
              "   000   000        " \
              "      000           " \
              "      000           " \
              "   000   000        " \
              "   000   000        "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 3, y: 0}, {x: 3, y: 1}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 3, y: 4}, {x: 3, y: 5}, {x: 5, y: 5}, {x: 5, y: 4}, {x: 9, y: 4}, {x: 9, y: 5}, {x: 11, y: 5}, {x: 11, y: 4}, {x: 9, y: 4}, {x: 8, y: 3}, {x: 8, y: 2}, {x: 9, y: 1}, {x: 11, y: 1}, {x: 11, y: 0}, {x: 9, y: 0}, {x: 9, y: 1}, {x: 5, y: 1}, {x: 5, y: 0}], inner: []}])
    end
  end
end
