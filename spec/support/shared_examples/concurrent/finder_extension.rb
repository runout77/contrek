RSpec.shared_examples "finder_extension" do
  describe "various complex cases" do
    it "case during cpp porting 2" do
      chunk = "  XXXXXXXXXXX   " \
              "  XX   XX  XX   " \
              "  XX   XX  XX   " \
              "  XX   XX  XX   " \
              "  XXXXXXXXXXX   "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq(
        [{outer: [{x: 7, y: 0}, {x: 12, y: 0}, {x: 12, y: 4}, {x: 2, y: 4}, {x: 2, y: 0}],
          inner: [
            [{x: 7, y: 1}, {x: 3, y: 1}, {x: 3, y: 3}, {x: 7, y: 3}, {x: 7, y: 2}],
            [{x: 11, y: 1}, {x: 8, y: 1}, {x: 8, y: 3}, {x: 11, y: 3}, {x: 11, y: 2}]
          ]}]
      )
    end

    it "case 0" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "0000            0000" \
              "0000   000      0000" \
              "00000000000     0000" \
              "00000000000000000000" \
              "0000000  00000000000" \
              "0000000  00000000000" \
              "0000000   0000000000"
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 20),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 19, y: 0}, {x: 19, y: 7}, {x: 10, y: 7}, {x: 9, y: 6}, {x: 9, y: 5}, {x: 6, y: 5}, {x: 6, y: 7}, {x: 0, y: 7}, {x: 0, y: 0}], inner: [[{x: 16, y: 1}, {x: 3, y: 1}, {x: 3, y: 2}, {x: 7, y: 2}, {x: 9, y: 2}, {x: 10, y: 3}, {x: 16, y: 3}, {x: 16, y: 2}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{
        outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 7}, {x: 10, y: 7}, {x: 9, y: 6}, {x: 9, y: 5}, {x: 6, y: 5}, {x: 6, y: 7}, {x: 0, y: 7}, {x: 0, y: 0}],
        inner: [
          [{x: 3, y: 1}, {x: 3, y: 2}, {x: 7, y: 2}, {x: 9, y: 2}, {x: 10, y: 3}, {x: 16, y: 3}, {x: 16, y: 1}]
        ]
      }])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 7}, {x: 6, y: 7}, {x: 6, y: 5}, {x: 9, y: 5}, {x: 9, y: 6}, {x: 10, y: 7}, {x: 19, y: 7}, {x: 19, y: 0}, {x: 9, y: 0}], inner: [[{x: 7, y: 2}, {x: 3, y: 2}, {x: 3, y: 1}, {x: 16, y: 1}, {x: 16, y: 3}, {x: 10, y: 3}, {x: 9, y: 2}]]}])
    end

    it "case 1" do
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "000000        000000" \
              "0000    000     0000" \
              "00      000     0000" \
              "00000000000000000000" \
              "00000000000000000000" \
              "00     00000    0000" \
              "0000    0000    0000" \
              "000000         00000" \
              "000000000      00000" \
              "0000000000     00000" \
              "00000000000000000000" \
              "00000000000000000000" \
              "00000000  0000000000" \
              "0000000    000000000" \
              "000000      00000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 16}, {x: 12, y: 16}, {x: 9, y: 13}, {x: 7, y: 14}, {x: 5, y: 16}, {x: 0, y: 16}, {x: 0, y: 0}], inner: [[{x: 5, y: 2}, {x: 1, y: 4}, {x: 8, y: 4}, {x: 8, y: 3}, {x: 10, y: 3}, {x: 10, y: 4}, {x: 16, y: 4}, {x: 16, y: 3}, {x: 14, y: 2}], [{x: 8, y: 8}, {x: 7, y: 7}, {x: 1, y: 7}, {x: 5, y: 9}, {x: 8, y: 10}, {x: 9, y: 11}, {x: 15, y: 11}, {x: 15, y: 9}, {x: 16, y: 8}, {x: 16, y: 7}, {x: 11, y: 7}, {x: 11, y: 8}]]}])
    end

    it "case 2" do
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "000000        000000" \
              "0000    000     0000" \
              "00      000     0000" \
              "00000000000000000000" \
              "00000000000000000000" \
              "00     00000    0000" \
              "0000    0000    0000" \
              "000000         00000" \
              "000000000      00000" \
              "0000000000     00000" \
              "00000000000000000000" \
              "00000000 00000000000" \
              "00000000  0000000000" \
              "0000000    000000000" \
              "000000      00000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 16}, {x: 12, y: 16}, {x: 9, y: 13}, {x: 7, y: 13}, {x: 7, y: 14}, {x: 5, y: 16}, {x: 0, y: 16}, {x: 0, y: 0}], inner: [[{x: 5, y: 2}, {x: 1, y: 4}, {x: 8, y: 4}, {x: 8, y: 3}, {x: 10, y: 3}, {x: 10, y: 4}, {x: 16, y: 4}, {x: 16, y: 3}, {x: 14, y: 2}], [{x: 8, y: 8}, {x: 7, y: 7}, {x: 1, y: 7}, {x: 5, y: 9}, {x: 8, y: 10}, {x: 9, y: 11}, {x: 15, y: 11}, {x: 15, y: 9}, {x: 16, y: 8}, {x: 16, y: 7}, {x: 11, y: 7}, {x: 11, y: 8}]]}])
    end

    it "case 3" do
      #        ---------*---------*----------
      #        012345678901234567890123456789
      chunk = "000000000000000000000000000000" \
              "000000000000000000000000000000" \
              "0000000000000000        000000" \
              "00000000000000    000     0000" \
              "000000000000      000     0000" \
              "000000000000000000000000000000" \
              "000000000000000000000000000000" \
              "000000000000     00000    0000" \
              "00000000000000    0000    0000" \
              "0000000000000000         00000" \
              "0000000000000000000      00000" \
              "00000000000000000000     00000" \
              "000000000000000000000000000000" \
              "000000000000000000 00000000000" \
              "000000000000000000  0000000000" \
              "00000000000000000    000000000" \
              "0000000000000000      00000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 30),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 16}, {x: 9, y: 16}, {x: 15, y: 16}, {x: 17, y: 14}, {x: 17, y: 13}, {x: 19, y: 13}, {x: 22, y: 16}, {x: 29, y: 16}, {x: 29, y: 0}, {x: 9, y: 0}], inner: [[{x: 18, y: 10}, {x: 15, y: 9}, {x: 11, y: 7}, {x: 17, y: 7}, {x: 18, y: 8}, {x: 21, y: 8}, {x: 21, y: 7}, {x: 26, y: 7}, {x: 26, y: 8}, {x: 25, y: 9}, {x: 25, y: 11}, {x: 19, y: 11}], [{x: 18, y: 3}, {x: 18, y: 4}, {x: 11, y: 4}, {x: 15, y: 2}, {x: 24, y: 2}, {x: 26, y: 3}, {x: 26, y: 4}, {x: 20, y: 4}, {x: 20, y: 3}]]}])
    end

    it "limits number of sequences" do
      chunk = "  0000  0000000000000000000000" \
              "  0000  0000000000000000000000" \
              "  0000  0000000000000000000000" \
              "                              " \
              "       00000     0000     0000" \
              "       00000     0000     0000" \
              "       00000     0000     0000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 30),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([
        {outer: [{x: 2, y: 0}, {x: 2, y: 2}, {x: 5, y: 2}, {x: 5, y: 0}], inner: []},
        {outer: [{x: 8, y: 0}, {x: 8, y: 2}, {x: 9, y: 2}, {x: 29, y: 2}, {x: 29, y: 0}, {x: 9, y: 0}], inner: []},
        {outer: [{x: 7, y: 4}, {x: 7, y: 6}, {x: 11, y: 6}, {x: 11, y: 4}, {x: 9, y: 4}], inner: []},
        {outer: [{x: 17, y: 4}, {x: 17, y: 6}, {x: 19, y: 6}, {x: 20, y: 6}, {x: 20, y: 4}, {x: 19, y: 4}], inner: []},
        {outer: [{x: 26, y: 4}, {x: 26, y: 6}, {x: 29, y: 6}, {x: 29, y: 4}], inner: []}
      ])
    end

    it "case foil" do
      chunk = "000000000000" \
              "000000000000" \
              "0000   00000" \
              "00000   0000" \
              "0000000  000" \
              "00000000   0" \
              "000000000  0" \
              "000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 12),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 7}, {x: 5, y: 7}, {x: 11, y: 7}, {x: 11, y: 0}, {x: 5, y: 0}], inner: [[{x: 4, y: 3}, {x: 3, y: 2}, {x: 7, y: 2}, {x: 9, y: 4}, {x: 11, y: 5}, {x: 11, y: 6}, {x: 8, y: 6}, {x: 6, y: 4}]]}])
    end

    it "case foliage" do
      #        -----*-------
      chunk = "0000000000000" \
              "0000000000000" \
              "0000000000   " \
              " 00000       " \
              "  0000   0000" \
              "0000000000000" \
              "0000000000000" \
              "0000000000   " \
              "0000000      " \
              " 000000    00" \
              "  00000000000" \
              "  000000000  " \
              "  0000000    " \
              "0000000     0" \
              "0000000000000" \
              "0000000000000" \
              "0000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 13),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 2}, {x: 2, y: 4}, {x: 0, y: 5}, {x: 0, y: 8}, {x: 2, y: 10}, {x: 2, y: 12}, {x: 0, y: 13}, {x: 0, y: 16}, {x: 5, y: 16}, {x: 12, y: 16}, {x: 12, y: 13}, {x: 6, y: 13}, {x: 12, y: 10}, {x: 12, y: 9}, {x: 11, y: 9}, {x: 6, y: 9}, {x: 6, y: 8}, {x: 12, y: 6}, {x: 12, y: 4}, {x: 9, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 9, y: 2}, {x: 12, y: 1}, {x: 12, y: 0}, {x: 5, y: 0}], inner: []}])
    end

    it "case foliage multiple workers" do
      #        -----*-----*-----*-----*------
      #        012345678901234567890123456789
      chunk = "000000000000000000000000000000" \
              "000000000000000000000000000000" \
              "000      000000000000     0000" \
              "0000        00000        00000" \
              "000000000    0000   0000000000" \
              "000000000000000000000000000000" \
              "000000000000000000000000000000" \
              "00000   0000000000000     0000" \
              "000000    00000000       00000" \
              "00000000    000000    00000000" \
              "000000000    00000000000000000" \
              "0000   000   000000000     000" \
              "00000   000  0000000     00000" \
              "0000000  000000000     0000000" \
              "00000000   0000000000000000000" \
              "000000000  0000000000000000000" \
              "000000000000000000000000000000"
      @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 30),
        matcher: @matcher,
        options: {number_of_tiles: 5, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect([{outer: [{x: 0, y: 0}, {x: 0, y: 16}, {x: 5, y: 16}, {x: 29, y: 16}, {x: 29, y: 0}, {x: 5, y: 0}], inner: [[{x: 4, y: 12}, {x: 3, y: 11}, {x: 7, y: 11}, {x: 9, y: 13}, {x: 11, y: 14}, {x: 11, y: 15}, {x: 8, y: 15}, {x: 6, y: 13}], [{x: 10, y: 12}, {x: 7, y: 9}, {x: 5, y: 8}, {x: 4, y: 7}, {x: 5, y: 6}, {x: 8, y: 7}, {x: 12, y: 9}, {x: 13, y: 10}, {x: 13, y: 12}], [{x: 8, y: 4}, {x: 5, y: 4}, {x: 3, y: 3}, {x: 2, y: 2}, {x: 5, y: 1}, {x: 9, y: 2}, {x: 12, y: 3}, {x: 13, y: 4}], [{x: 23, y: 13}, {x: 17, y: 13}, {x: 21, y: 11}, {x: 27, y: 11}, {x: 25, y: 12}], [{x: 22, y: 9}, {x: 17, y: 9}, {x: 17, y: 8}, {x: 20, y: 7}, {x: 26, y: 7}, {x: 25, y: 8}], [{x: 20, y: 4}, {x: 17, y: 5}, {x: 16, y: 4}, {x: 16, y: 3}, {x: 17, y: 2}, {x: 20, y: 2}, {x: 26, y: 2}, {x: 25, y: 3}]]}])
    end

    it "case contiguous expanding top to bottom hole" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "0000     00000000000" \
              "0000     00000000000" \
              "0000          000000" \
              "0000000000    000000" \
              "0000000000    000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 6}, {x: 9, y: 6}, {x: 19, y: 6}, {x: 19, y: 0}, {x: 9, y: 0}], inner: [[{x: 3, y: 3}, {x: 3, y: 1}, {x: 9, y: 1}, {x: 9, y: 2}, {x: 14, y: 3}, {x: 14, y: 5}, {x: 9, y: 5}, {x: 9, y: 4}]]}])
    end

    it "case foliage 2" do
      chunk = "000000000000" \
              "000000000000" \
              "00000   0000" \
              "000000    00" \
              "00000000    " \
              "000000000   " \
              "0000   000  " \
              "00000   000 " \
              "0000000  000" \
              "00000000   0" \
              "000000000  0" \
              "000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 12),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 11}, {x: 5, y: 11}, {x: 11, y: 11}, {x: 11, y: 8}, {x: 7, y: 4}, {x: 5, y: 3}, {x: 4, y: 2}, {x: 5, y: 1}, {x: 8, y: 2}, {x: 10, y: 3}, {x: 11, y: 3}, {x: 11, y: 0}, {x: 5, y: 0}], inner: [[{x: 4, y: 7}, {x: 3, y: 6}, {x: 7, y: 6}, {x: 9, y: 8}, {x: 11, y: 9}, {x: 11, y: 10}, {x: 8, y: 10}, {x: 6, y: 8}]]}])
    end

    it "case problematic contiguous disconnected shapes side right" do
      chunk = "   000000000000     " \
              "   00  00000000     " \
              "   000000000000     " \
              "          00000     " \
              "          0   0     " \
              "          00000     " \
              "   000000000000     " \
              "   00    000000     " \
              "   000000000000     "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{
        outer: [{x: 3, y: 0}, {x: 3, y: 2}, {x: 9, y: 2}, {x: 10, y: 3}, {x: 10, y: 5}, {x: 9, y: 6}, {x: 3, y: 6}, {x: 3, y: 8}, {x: 9, y: 8}, {x: 14, y: 8}, {x: 14, y: 0}, {x: 9, y: 0}],
        inner: [[{x: 4, y: 1}, {x: 7, y: 1}], [{x: 10, y: 4}, {x: 14, y: 4}], [{x: 4, y: 7}, {x: 9, y: 7}]]
      }])
    end

    it "case problematic contiguous disconnected shapes side left" do
      chunk = "00000000000000000000" \
              "00         000000000" \
              "00000000000000000000" \
              "000000000           " \
              "000000000           " \
              "00000000000000000000" \
              "00         000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 7}, {x: 9, y: 7}, {x: 19, y: 7}, {x: 19, y: 5}, {x: 9, y: 5}, {x: 8, y: 4}, {x: 8, y: 3}, {x: 9, y: 2}, {x: 19, y: 2}, {x: 19, y: 0}, {x: 9, y: 0}],
         inner: [[{x: 1, y: 6}, {x: 11, y: 6}], [{x: 1, y: 1}, {x: 11, y: 1}]]}
      ])
    end

    it "case problematic contiguous disconnected shapes side right solid" do
      chunk = "00000000000000000000" \
              "00         000000000" \
              "00000000000000000000" \
              "          0000000000" \
              "          0000000000" \
              "00000000000000000000" \
              "00         000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{
        outer: [{x: 0, y: 0}, {x: 0, y: 2}, {x: 9, y: 2}, {x: 10, y: 3}, {x: 10, y: 4}, {x: 9, y: 5}, {x: 0, y: 5}, {x: 0, y: 7}, {x: 9, y: 7}, {x: 19, y: 7}, {x: 19, y: 0}, {x: 9, y: 0}],
        inner: [[{x: 1, y: 1}, {x: 11, y: 1}], [{x: 11, y: 6}, {x: 1, y: 6}]]
      }])
    end

    it "case problematic contiguous disconnected shapes extending to full height right rectangle" do
      chunk = "00000000000000000000" \
              "00         00      0" \
              "0000000000000      0" \
              "          000      0" \
              "          000      0" \
              "0000000000000      0" \
              "00         00      0" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 2}, {x: 9, y: 2}, {x: 10, y: 3}, {x: 10, y: 4}, {x: 9, y: 5}, {x: 0, y: 5}, {x: 0, y: 7}, {x: 9, y: 7}, {x: 19, y: 7}, {x: 19, y: 0}, {x: 9, y: 0}],
                                        inner: [
                                          [{x: 1, y: 1}, {x: 11, y: 1}],
                                          [{x: 11, y: 6}, {x: 1, y: 6}],
                                          [{x: 12, y: 1}, {x: 19, y: 1}, {x: 19, y: 6}, {x: 12, y: 6}, {x: 12, y: 2}]
                                        ]}])
    end

    it "multiple alternating disconnected shapes" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00         000000000" \
              "00000000000000000000" \
              "000000000           " \
              "00000000000000000000" \
              "           000000000" \
              "00000000000000000000" \
              "000000000           " \
              "00000000000000000000" \
              "00         000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{
        outer: [{x: 0, y: 0}, {x: 0, y: 4}, {x: 9, y: 4}, {x: 11, y: 5}, {x: 9, y: 6}, {x: 0, y: 6}, {x: 0, y: 10}, {x: 9, y: 10}, {x: 19, y: 10}, {x: 19, y: 8}, {x: 9, y: 8}, {x: 8, y: 7}, {x: 9, y: 6}, {x: 19, y: 6}, {x: 19, y: 4}, {x: 9, y: 4}, {x: 8, y: 3}, {x: 9, y: 2}, {x: 19, y: 2}, {x: 19, y: 0}, {x: 9, y: 0}],
        inner: [[{x: 1, y: 1}, {x: 11, y: 1}], [{x: 1, y: 9}, {x: 11, y: 9}]]
      }])
    end

    it "multiple alternating disconnected shapes (case 2)" do
      chunk = "00000000000000000000" \
              "00         000000000" \
              "00000000000000000000" \
              "000000000           " \
              "00000000000000000000" \
              "           000000000" \
              "00000000000000000000" \
              "000000000           " \
              "00000000000000000000" \
              "00         000000000" \
              "00         000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{
        outer: [{x: 0, y: 0}, {x: 0, y: 4}, {x: 9, y: 4}, {x: 11, y: 5}, {x: 9, y: 6}, {x: 0, y: 6}, {x: 0, y: 11}, {x: 9, y: 11}, {x: 19, y: 11}, {x: 19, y: 8}, {x: 9, y: 8}, {x: 8, y: 7}, {x: 9, y: 6}, {x: 19, y: 6}, {x: 19, y: 4}, {x: 9, y: 4}, {x: 8, y: 3}, {x: 9, y: 2}, {x: 19, y: 2}, {x: 19, y: 0}, {x: 9, y: 0}],
        inner: [[{x: 1, y: 1}, {x: 11, y: 1}], [{x: 1, y: 10}, {x: 1, y: 9}, {x: 11, y: 9}, {x: 11, y: 10}]]
      }])
    end

    it "complex disconnected shapes case with sew technic" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "0                  0" \
              "00000000000        0" \
              "          0        0" \
              "          0        0" \
              "00000000000        0" \
              "0                  0" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 2}, {x: 9, y: 2}, {x: 10, y: 3}, {x: 10, y: 4}, {x: 9, y: 5}, {x: 0, y: 5}, {x: 0, y: 7}, {x: 9, y: 7}, {x: 19, y: 7}, {x: 19, y: 0}, {x: 9, y: 0}], inner: [[{x: 0, y: 1}, {x: 19, y: 1}, {x: 19, y: 6}, {x: 0, y: 6}, {x: 10, y: 5}, {x: 10, y: 2}]]}])
    end

    it "one pixel trampled twice needed rethink (and rewrite) the whole" do
      #        ---------*----------
      chunk = "     000000         " \
              "     00 000         " \
              "    000 000         " \
              "   0000 000         " \
              "  00000  0          " \
              "  0000   0          " \
              "  0000   00         " \
              "  000    00         " \
              "          00        " \
              "           00       " \
              "           00       " \
              "           00       " \
              "          0000      " \
              "          00000     " \
              "          0000000   "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 5, y: 0}, {x: 5, y: 1}, {x: 2, y: 4}, {x: 2, y: 7}, {x: 4, y: 7}, {x: 5, y: 6}, {x: 5, y: 5}, {x: 6, y: 4}, {x: 6, y: 1}, {x: 8, y: 1}, {x: 8, y: 3}, {x: 9, y: 4}, {x: 9, y: 7}, {x: 11, y: 9}, {x: 11, y: 11}, {x: 10, y: 12}, {x: 10, y: 14}, {x: 16, y: 14}, {x: 14, y: 13}, {x: 12, y: 11}, {x: 12, y: 9}, {x: 10, y: 7}, {x: 10, y: 6}, {x: 9, y: 5}, {x: 9, y: 4}, {x: 10, y: 3}, {x: 10, y: 0}, {x: 9, y: 0}], inner: []}])
    end

    it "two pixel case" do
      chunk = "XXXXXXX             " \
              "XXXXXXX         X   " \
              "XXXXXXXXX    XXX    " \
              "        XXXXXX      " \
              "          XXX       " \
              "         XX         " \
              "        XX          "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 2}, {x: 8, y: 3}, {x: 9, y: 3}, {x: 10, y: 4}, {x: 8, y: 6}, {x: 9, y: 6}, {x: 10, y: 5}, {x: 12, y: 4}, {x: 13, y: 3}, {x: 15, y: 2}, {x: 13, y: 2}, {x: 9, y: 3}, {x: 8, y: 2}, {x: 6, y: 1}, {x: 6, y: 0}], inner: []}])
    end

    it "one pixel lower connecting tiles" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "0              00000" \
              "00000000000    00000" \
              "00000000000    00000" \
              "000000000000   00000" \
              "00000000000000000000" \
              "00000000000000000000" \
              "0000000    000000000" \
              "0          000000000" \
              "0          000000000" \
              "0        00000000000" \
              "0         0000000000" \
              "0        00000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 13}, {x: 9, y: 13}, {x: 0, y: 13}, {x: 0, y: 0}],
                                        inner: [[{x: 0, y: 1}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 11, y: 4}, {x: 15, y: 4}, {x: 15, y: 1}], [{x: 6, y: 7}, {x: 0, y: 8}, {x: 0, y: 12}, {x: 9, y: 12}, {x: 10, y: 11}, {x: 9, y: 10}, {x: 11, y: 9}, {x: 11, y: 7}]]}])
    end

    it "foliage problem to solve" do
      #        ---------*----------
      chunk = "                  00" \
              "                0000" \
              "               000  " \
              "               00   " \
              "              000   " \
              "    000  00   00    " \
              "   0000 0000 000    " \
              "  00000000000000    " \
              "  0000000000 000    " \
              "   0000 0000 000    " \
              "             000    " \
              "        00   000    " \
              "       000  00000   " \
              "      0000  00000000" \
              "     00000 000000000" \
              "    000000 000000000" \
              "    00000   0000000 " \
              "   000000  000000 0 " \
              "   000000  00 0     " \
              "   000000 00 00   00" \
              "0 000000  00  0 0000" \
              "0 000000  00    000 " \
              "0  0000    00 0000  " \
              "0  000     000000 00" \
              "00 00       000 0000" \
              "00 0       000000000" \
              "0000      0000000000" \
              "0 00     00000    00" \
              "0 00    0000000     " \
              "  00   000000000    " \
              "  00  000000  000   " \
              "  00 000 0000000 0 0" \
              "  000000000 000 0000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 4, y: 5}, {x: 2, y: 7}, {x: 2, y: 8}, {x: 3, y: 9}, {x: 6, y: 9}, {x: 8, y: 9}, {x: 9, y: 9}, {x: 11, y: 9}, {x: 11, y: 8}, {x: 13, y: 8}, {x: 13, y: 11}, {x: 12, y: 12}, {x: 12, y: 13}, {x: 11, y: 14}, {x: 11, y: 15}, {x: 12, y: 16}, {x: 11, y: 17}, {x: 11, y: 18}, {x: 10, y: 19}, {x: 10, y: 21}, {x: 11, y: 22}, {x: 11, y: 23}, {x: 12, y: 24}, {x: 5, y: 31}, {x: 3, y: 31}, {x: 3, y: 25}, {x: 7, y: 21}, {x: 7, y: 20}, {x: 8, y: 19}, {x: 8, y: 16}, {x: 9, y: 15}, {x: 9, y: 11}, {x: 8, y: 11}, {x: 4, y: 15}, {x: 4, y: 16}, {x: 3, y: 17}, {x: 3, y: 19}, {x: 2, y: 20}, {x: 2, y: 21}, {x: 3, y: 22}, {x: 3, y: 25}, {x: 1, y: 25}, {x: 1, y: 24}, {x: 0, y: 20}, {x: 0, y: 23}, {x: 0, y: 28}, {x: 0, y: 27}, {x: 2, y: 27}, {x: 2, y: 32}, {x: 9, y: 32}, {x: 10, y: 32}, {x: 14, y: 32}, {x: 16, y: 30}, {x: 13, y: 27}, {x: 18, y: 27}, {x: 19, y: 27}, {x: 19, y: 23}, {x: 18, y: 23}, {x: 16, y: 23}, {x: 19, y: 20}, {x: 19, y: 19}, {x: 18, y: 19}, {x: 16, y: 20}, {x: 16, y: 21}, {x: 14, y: 22}, {x: 12, y: 22}, {x: 11, y: 21}, {x: 11, y: 19}, {x: 12, y: 18}, {x: 14, y: 18}, {x: 13, y: 19}, {x: 14, y: 20}, {x: 14, y: 18}, {x: 16, y: 17}, {x: 18, y: 17}, {x: 18, y: 16}, {x: 19, y: 15}, {x: 19, y: 13}, {x: 16, y: 12}, {x: 15, y: 11}, {x: 15, y: 5}, {x: 16, y: 4}, {x: 16, y: 3}, {x: 17, y: 2}, {x: 19, y: 1}, {x: 19, y: 0}, {x: 18, y: 0}, {x: 16, y: 1}, {x: 15, y: 2}, {x: 15, y: 3}, {x: 14, y: 4}, {x: 14, y: 5}, {x: 13, y: 6}, {x: 11, y: 6}, {x: 10, y: 5}, {x: 9, y: 5}, {x: 8, y: 6}, {x: 6, y: 6}, {x: 6, y: 5}], inner: [[{x: 14, y: 24}, {x: 16, y: 24}], [{x: 11, y: 30}, {x: 14, y: 30}], [{x: 9, y: 31}, {x: 7, y: 31}]]}, {outer: [{x: 17, y: 31}, {x: 16, y: 32}, {x: 19, y: 32}, {x: 19, y: 31}, {x: 17, y: 31}], inner: []}])
    end

    it "foliage problem to solve 2" do
      #        ---------*---------*---------*----------
      #        0123456789012345678901234567890123456789
      chunk = "                  000000000             " \
              "                   00000000             " \
              "                     0000000000000      " \
              "                              000       " \
              "        00000000000000000000000         " \
              "         000000000000000000000          "

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 9, y: 4}, {x: 29, y: 4}, {x: 30, y: 3}, {x: 29, y: 2}, {x: 21, y: 2}, {x: 19, y: 1}, {x: 18, y: 0}, {x: 19, y: 0}, {x: 26, y: 0}, {x: 26, y: 1}, {x: 29, y: 2}, {x: 33, y: 2}, {x: 32, y: 3}, {x: 30, y: 4}, {x: 29, y: 5}, {x: 9, y: 5}, {x: 8, y: 4}], inner: []}])
    end

    it "foliage problem to solve 3" do
      #        ---------*---------*---------*----------
      #        0123456789012345678901234567890123456789
      chunk = "               00000                    " \
              "               000 7                    " \
              "              0000 61                   " \
              "              0000  0                   " \
              "             0000   00                  " \
              "             0000   000                 " \
              "             0000    0000               " \
              "             0000   5000000             " \
              "            0000   40  00000            " \
              "            0000  000   00000           " \
              "            000   000   00000           " \
              "            000  3020    00000          "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 19, y: 0}, {x: 19, y: 1}, {x: 20, y: 2}, {x: 20, y: 3}, {x: 22, y: 5}, {x: 26, y: 7}, {x: 28, y: 9}, {x: 28, y: 10}, {x: 29, y: 11}, {x: 25, y: 11}, {x: 24, y: 10}, {x: 24, y: 9}, {x: 23, y: 8}, {x: 20, y: 8}, {x: 20, y: 11}, {x: 19, y: 11}, {x: 17, y: 11}, {x: 18, y: 10}, {x: 18, y: 9}, {x: 21, y: 6}, {x: 20, y: 5}, {x: 20, y: 3}, {x: 19, y: 2}, {x: 19, y: 1}, {x: 17, y: 1}, {x: 17, y: 3}, {x: 16, y: 4}, {x: 16, y: 7}, {x: 15, y: 8}, {x: 15, y: 9}, {x: 14, y: 10}, {x: 14, y: 11}, {x: 12, y: 11}, {x: 12, y: 8}, {x: 13, y: 7}, {x: 13, y: 4}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 15, y: 1}, {x: 15, y: 0}], inner: []}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info

      expect(result[:polygons]).to eq([{
        outer: [
          {x: 15, y: 0}, {x: 15, y: 1}, {x: 14, y: 2}, {x: 14, y: 3}, {x: 13, y: 4},
          {x: 13, y: 7}, {x: 12, y: 8}, {x: 12, y: 11}, {x: 14, y: 11}, {x: 14, y: 10},
          {x: 15, y: 9}, {x: 15, y: 8}, {x: 16, y: 7}, {x: 16, y: 4}, {x: 17, y: 3},
          {x: 17, y: 1}, {x: 19, y: 1}, {x: 19, y: 2}, {x: 20, y: 3}, {x: 20, y: 5},
          {x: 21, y: 6}, {x: 18, y: 9}, {x: 18, y: 10}, {x: 17, y: 11}, {x: 19, y: 11},
          {x: 20, y: 11}, {x: 20, y: 8}, {x: 23, y: 8}, {x: 24, y: 9}, {x: 24, y: 10},
          {x: 25, y: 11}, {x: 29, y: 11}, {x: 28, y: 10}, {x: 28, y: 9}, {x: 26, y: 7},
          {x: 22, y: 5}, {x: 20, y: 3}, {x: 20, y: 2}, {x: 19, y: 1}, {x: 19, y: 0}
        ],
        inner: []
      }])
    end

    it "same sequence loop stop issue" do
      #        ---------*----------
      #        01234567890123456789
      chunk = "     000000000000000" \
              "0000000        0    " \
              "0000                "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 15, y: 1}, {x: 9, y: 0}, {x: 3, y: 2}, {x: 0, y: 2}, {x: 0, y: 1}, {x: 5, y: 0}], inner: []}])
    end

    it "same sequence loop stop issue (three workers)" do
      #        ---------*---------*----------
      #        012345678901234567890123456789
      chunk = "     000000000000000000       " \
              "0000000        0      00000000" \
              " 000                   0000000" \
              "                        000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 30),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 22, y: 0}, {x: 29, y: 1}, {x: 29, y: 3}, {x: 24, y: 3}, {x: 22, y: 1}, {x: 19, y: 0}, {x: 15, y: 1}, {x: 9, y: 0}, {x: 3, y: 2}, {x: 1, y: 2}, {x: 0, y: 1}, {x: 5, y: 0}], inner: []}])
    end

    it "same sequence loop stop issue (three workers) case 2" do
      #        ---------*---------*---------*----------
      #        0123456789012345678901234567890123456789
      chunk = "             00000                      " \
              "             00000 0                    " \
              "             00000 000000000            " \
              "             00000 000000000            " \
              "             000000000000000            " \
              "             000000000000000            " \
              "             00000000000000000          " \
              "             0000000000000000           " \
              "             0000000000000000           "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 17, y: 0}, {x: 17, y: 3}, {x: 19, y: 3}, {x: 19, y: 1}, {x: 27, y: 2}, {x: 27, y: 5}, {x: 29, y: 6}, {x: 28, y: 7}, {x: 28, y: 8}, {x: 19, y: 8}, {x: 13, y: 8}, {x: 13, y: 0}], inner: []}])
    end

    it "foliage problem to solve 4" do
      #        ---------*----------*---------*---------
      #        0123456789012345678901234567890123456789
      chunk = "               0000000                  " \
              "             0000000000                 " \
              "           00000   0000                 " \
              "          00000 0 0000                  " \
              "          000  000000                   " \
              "         000  000000000000              " \
              "        000  00000000000000             " \
              "        000 000000000000000             " \
              "      0000  000000000000000             " \
              "     00000 000000000000000              " \
              "    000000  000000000000                " \
              "   00000000  00000000                   " \
              "   00000000 0 000000000                 " \
              " 000000000000       0000                " \
              "0000000000000000 0    000               " \
              "0000000000000000000000000               " \
              "000000000000000000000000                " \
              "000000000000000000000000                " \
              "0000000000000000000000000000            " \
              "00000000000000000000000000000000000    0" \
              "0000000000000000000000000000000000000000" \
              "0000000000000000000             00000000" \
              "0000000000000000000           0000000000" \
              "0000000000000000000     0 0 000000000000" \
              "000000000000000000000 000000000000000000" \
              "0000000000000000000000000000000000000000"
      # the x=19,y=2 point is the one creates issue to solve
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 9, y: 5}, {x: 8, y: 6}, {x: 8, y: 7}, {x: 6, y: 8}, {x: 3, y: 11}, {x: 3, y: 12}, {x: 1, y: 13}, {x: 0, y: 14}, {x: 0, y: 25}, {x: 9, y: 25}, {x: 39, y: 25}, {x: 39, y: 19}, {x: 29, y: 19}, {x: 27, y: 18}, {x: 23, y: 17}, {x: 23, y: 16}, {x: 24, y: 15}, {x: 24, y: 14}, {x: 22, y: 12}, {x: 20, y: 11}, {x: 23, y: 10}, {x: 25, y: 9}, {x: 26, y: 8}, {x: 26, y: 6}, {x: 25, y: 5}, {x: 20, y: 4}, {x: 22, y: 2}, {x: 22, y: 1}, {x: 21, y: 0}, {x: 19, y: 0}, {x: 15, y: 0}, {x: 11, y: 2}, {x: 10, y: 3}, {x: 10, y: 4}], inner: [[{x: 18, y: 23}, {x: 18, y: 21}, {x: 29, y: 20}, {x: 32, y: 21}, {x: 30, y: 22}, {x: 29, y: 23}, {x: 28, y: 23}, {x: 24, y: 23}, {x: 22, y: 24}, {x: 20, y: 24}], [{x: 17, y: 14}, {x: 15, y: 14}, {x: 12, y: 13}, {x: 12, y: 12}, {x: 10, y: 12}, {x: 10, y: 11}, {x: 9, y: 10}, {x: 9, y: 8}, {x: 10, y: 7}, {x: 10, y: 6}, {x: 12, y: 4}, {x: 14, y: 3}, {x: 15, y: 2}, {x: 19, y: 2}, {x: 18, y: 3}, {x: 16, y: 3}, {x: 12, y: 7}, {x: 12, y: 8}, {x: 11, y: 9}, {x: 14, y: 12}, {x: 20, y: 13}, {x: 22, y: 14}]]}])
    end

    it "foliage problem to solve 5" do
      chunk = "00000000000000000000           " \
              "00000000000000000000           " \
              "0000000000   0000000           " \
              "000000000 0 00000000           " \
              "0000000  00000000000           " \
              "000000  000000000000           " \
              "00000  0000000000000           " \
              "00000 00000000     0           " \
              "0000  00000   000000           " \
              "0000       000000000           " \
              "0000    000000000000           " \
              "00000  00000000                " \
              "00000  0000000000000           " \
              "0000000       000000           " \
              "0000000000      0000           " \
              "00000000000000000000           " \
              "00000000000000000000           " \
              "00000000000000000000           " \
              "00000000000000000000           " \
              "0000000000000000000000000000000" \
              "0000000000000000000000000000000" \
              "0000000000000             00000" \
              "0000000000000           0000000" \
              "0000000000000     0 0 000000000" \
              "000000000000000 000000000000000" \
              "0000000000000000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 31),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 25}, {x: 6, y: 25}, {x: 30, y: 25}, {x: 30, y: 19}, {x: 22, y: 19}, {x: 19, y: 18}, {x: 19, y: 12}, {x: 14, y: 11}, {x: 19, y: 10}, {x: 19, y: 0}, {x: 14, y: 0}, {x: 6, y: 0}], inner: [[{x: 12, y: 23}, {x: 12, y: 21}, {x: 22, y: 20}, {x: 26, y: 21}, {x: 22, y: 23}, {x: 18, y: 23}, {x: 16, y: 24}, {x: 14, y: 24}], [{x: 9, y: 14}, {x: 6, y: 13}, {x: 4, y: 12}, {x: 4, y: 11}, {x: 3, y: 10}, {x: 3, y: 8}, {x: 4, y: 7}, {x: 4, y: 6}, {x: 6, y: 4}, {x: 8, y: 3}, {x: 9, y: 2}, {x: 13, y: 2}, {x: 12, y: 3}, {x: 10, y: 3}, {x: 6, y: 7}, {x: 6, y: 8}, {x: 10, y: 8}, {x: 13, y: 7}, {x: 19, y: 7}, {x: 14, y: 8}, {x: 8, y: 10}, {x: 7, y: 11}, {x: 7, y: 12}, {x: 14, y: 13}, {x: 16, y: 14}]]}])
    end

    it "foliage problem to solve 6" do
      #        ----------*-----------
      #        0123456789012345678901
      chunk = "                      " \
              "           00000      " \
              "         00000000     " \
              "       000     00     " \
              "     000        0     " \
              "    000        00     " \
              "    00       000      " \
              "000000000000000       " \
              "000000000000          " \
              "    00 0000000000     " \
              "    00    0000000000  " \
              "     00     000   00  " \
              "     00      00       " \
              "      00      00      " \
              "      00      00      " \
              "       00     00      " \
              "        00     0      " \
              "         00   00      " \
              "         0000000      " \
              "           0000       " \
              "                      "

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 9, y: 2}, {x: 5, y: 4}, {x: 4, y: 5}, {x: 4, y: 6}, {x: 0, y: 7}, {x: 0, y: 8}, {x: 4, y: 9}, {x: 4, y: 10}, {x: 5, y: 11}, {x: 5, y: 12}, {x: 6, y: 13}, {x: 6, y: 14}, {x: 9, y: 17}, {x: 9, y: 18}, {x: 10, y: 18}, {x: 11, y: 19}, {x: 14, y: 19}, {x: 15, y: 18}, {x: 15, y: 13}, {x: 14, y: 12}, {x: 14, y: 11}, {x: 18, y: 11}, {x: 19, y: 11}, {x: 19, y: 10}, {x: 16, y: 9}, {x: 11, y: 8}, {x: 14, y: 7}, {x: 16, y: 5}, {x: 16, y: 2}, {x: 15, y: 1}, {x: 11, y: 1}, {x: 10, y: 2}], inner: [[{x: 9, y: 16}, {x: 7, y: 14}, {x: 7, y: 13}, {x: 6, y: 12}, {x: 6, y: 11}, {x: 5, y: 10}, {x: 5, y: 9}, {x: 7, y: 9}, {x: 10, y: 10}, {x: 12, y: 11}, {x: 14, y: 13}, {x: 14, y: 15}, {x: 15, y: 16}, {x: 14, y: 17}, {x: 10, y: 17}], [{x: 5, y: 6}, {x: 7, y: 4}, {x: 9, y: 3}, {x: 15, y: 3}, {x: 16, y: 4}, {x: 15, y: 5}, {x: 13, y: 6}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{
        outer: [{x: 10, y: 2}, {x: 11, y: 1}, {x: 15, y: 1}, {x: 16, y: 2}, {x: 16, y: 5}, {x: 14, y: 7}, {x: 11, y: 8}, {x: 16, y: 9}, {x: 19, y: 10}, {x: 19, y: 11}, {x: 18, y: 11}, {x: 14, y: 11}, {x: 14, y: 12}, {x: 15, y: 13}, {x: 15, y: 18}, {x: 14, y: 19}, {x: 11, y: 19}, {x: 10, y: 18}, {x: 9, y: 18}, {x: 9, y: 17}, {x: 6, y: 14}, {x: 6, y: 13}, {x: 5, y: 12}, {x: 5, y: 11}, {x: 4, y: 10}, {x: 4, y: 9}, {x: 0, y: 8}, {x: 0, y: 7}, {x: 4, y: 6}, {x: 4, y: 5}, {x: 5, y: 4}, {x: 9, y: 2}],
        inner: [
          [{x: 9, y: 3}, {x: 7, y: 4}, {x: 5, y: 6}, {x: 13, y: 6}, {x: 15, y: 5}, {x: 16, y: 4}, {x: 15, y: 3}],
          [{x: 7, y: 9}, {x: 5, y: 9}, {x: 5, y: 10}, {x: 6, y: 11}, {x: 6, y: 12}, {x: 7, y: 13}, {x: 7, y: 14}, {x: 10, y: 17}, {x: 14, y: 17}, {x: 15, y: 16}, {x: 14, y: 15}, {x: 14, y: 13}, {x: 12, y: 11}, {x: 10, y: 10}]
        ]
      }])
    end

    it "foliage problem to solve 7" do
      #        ----------*----------
      #        0123456789012345678901
      chunk = "                      " \
              "        0000000       " \
              "        00000000      " \
              "      000     00      " \
              "    000        0      " \
              "   000        00      " \
              "   00       000       " \
              "00000000000000        " \
              "00000000000           " \
              "   00 0000000000      " \
              "   00    0000000000   " \
              "    00     000   00   " \
              "    00      00        " \
              "     00      00       " \
              "     00      00       " \
              "      00     00       " \
              "       00     0       " \
              "        00   00       " \
              "        0000000       " \
              "          0000        " \
              "                      "

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 10, y: 1}, {x: 14, y: 1}, {x: 15, y: 2}, {x: 15, y: 5}, {x: 13, y: 7}, {x: 10, y: 8}, {x: 15, y: 9}, {x: 18, y: 10}, {x: 18, y: 11}, {x: 17, y: 11}, {x: 13, y: 11}, {x: 13, y: 12}, {x: 14, y: 13}, {x: 14, y: 18}, {x: 13, y: 19}, {x: 10, y: 19}, {x: 8, y: 18}, {x: 8, y: 17}, {x: 5, y: 14}, {x: 5, y: 13}, {x: 4, y: 12}, {x: 4, y: 11}, {x: 3, y: 10}, {x: 3, y: 9}, {x: 0, y: 8}, {x: 0, y: 7}, {x: 3, y: 6}, {x: 3, y: 5}, {x: 4, y: 4}, {x: 8, y: 2}, {x: 8, y: 1}], inner: [[{x: 8, y: 3}, {x: 6, y: 4}, {x: 4, y: 6}, {x: 12, y: 6}, {x: 14, y: 5}, {x: 15, y: 4}, {x: 14, y: 3}], [{x: 9, y: 10}, {x: 6, y: 9}, {x: 4, y: 9}, {x: 4, y: 10}, {x: 5, y: 11}, {x: 5, y: 12}, {x: 6, y: 13}, {x: 6, y: 14}, {x: 9, y: 17}, {x: 13, y: 17}, {x: 14, y: 16}, {x: 13, y: 15}, {x: 13, y: 13}, {x: 11, y: 11}]]}])
    end

    # The algorithm for determining the outer sequence (outer) in certain circumstances
    # appends a copy of the first position at the end. If it exists, it is removed.
    # In the past, it was removed at every tile merge, but this was incorrect because,
    # as in this test case, merging tiles 0 and 1 removed the position (20,3) at the end
    # of the sequence, which had already been added at the start. Now, this removal during
    # the merge of base 01 and 2 did not convert the first part into a transmuted part
    # (which is a part composed of positions [20,2] and [20,3]), which, remaining IN, caused
    # an error in determining the outer boundary - effectively moving to the next part
    # too early.
    it "foliage problem to solve 8" do
      #        ---------*----------*-----------
      #        01234567890123456789012345678901
      chunk = "                     0          " \
              "                     0          " \
              "                    00          " \
              "                    0           " \
              "                   00           " \
              "                  000           " \
              "                00000           " \
              "               000000           " \
              "              00 0000           " \
              "             00 000 0           " \
              "             000 0  00          " \
              "            000 00  00          " \
              "           000  0  0000         " \
              "           0   00  00 0         " \
              "              00   0  0         " \
              "             000   0  0         " \
              "            0000   0 00         " \
              "           0000    0 0          " \
              "           000     0 0          " \
              "          000      000          " \
              "         000       00           " \
              "         00        00           " \
              "         0         0            " \
              "                                "
      pf = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 32),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      )
      result = pf.process_info
      expect(result[:polygons]).to eq([{outer: [{x: 20, y: 2}, {x: 20, y: 3}, {x: 18, y: 5}, {x: 16, y: 6}, {x: 13, y: 9}, {x: 13, y: 10}, {x: 11, y: 12}, {x: 11, y: 13}, {x: 13, y: 12}, {x: 15, y: 10}, {x: 14, y: 9}, {x: 15, y: 8}, {x: 17, y: 8}, {x: 16, y: 9}, {x: 17, y: 10}, {x: 16, y: 11}, {x: 16, y: 12}, {x: 11, y: 17}, {x: 11, y: 18}, {x: 9, y: 20}, {x: 9, y: 22}, {x: 15, y: 16}, {x: 15, y: 14}, {x: 16, y: 13}, {x: 16, y: 12}, {x: 17, y: 11}, {x: 17, y: 10}, {x: 18, y: 9}, {x: 20, y: 9}, {x: 20, y: 11}, {x: 19, y: 12}, {x: 19, y: 22}, {x: 20, y: 21}, {x: 20, y: 20}, {x: 21, y: 19}, {x: 21, y: 17}, {x: 22, y: 16}, {x: 22, y: 12}, {x: 21, y: 11}, {x: 21, y: 10}, {x: 20, y: 9}, {x: 20, y: 3}, {x: 21, y: 2}, {x: 21, y: 0}, {x: 21, y: 1}], inner: [[{x: 19, y: 18}, {x: 19, y: 14}, {x: 20, y: 13}, {x: 22, y: 13}, {x: 22, y: 15}, {x: 21, y: 16}, {x: 21, y: 18}]]}])
    end
  end
end
