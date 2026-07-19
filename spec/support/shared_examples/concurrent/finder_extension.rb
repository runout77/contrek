# frozen_string_literal: true

RSpec.shared_examples "finder_extension" do
  describe "finder_extension" do
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
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to eq([{outer: [{x: 20, y: 0}, {x: 20, y: 8}, {x: 10, y: 8}, {x: 10, y: 7}, {x: 9, y: 7}, {x: 9, y: 5}, {x: 7, y: 5}, {x: 7, y: 8}, {x: 0, y: 8}, {x: 0, y: 0}], inner: [[{x: 16, y: 1}, {x: 4, y: 1}, {x: 4, y: 3}, {x: 7, y: 3}, {x: 7, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 11, y: 3}, {x: 11, y: 4}, {x: 16, y: 4}, {x: 16, y: 2}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 30),
        matcher: @matcher,
        options: {number_of_tiles: 5, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
    end

    it "case vertical one pixel hole" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000 00000000000" \
              "00000000 00000000000" \
              "00000000 00000000000" \
              "00000000 00000000000" \
              "00000000 00000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "case vertical one pixel hole part 2" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "000000000 0000000000" \
              "000000000 0000000000" \
              "000000000 0000000000" \
              "000000000 0000000000" \
              "000000000 0000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "case missing pixel" do
      #        ---------*----------
      chunk = "     0000           " \
              "     00000          " \
              "                    "
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 20),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 9, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}, {x: 5, y: 2}, {x: 5, y: 0}], inner: []}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json(addons: [:o])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json(addons: [:o])
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
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 32),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "eye of the beholder" do
      #        ---------*----------*-----------
      #        0123456789012345678901234567890
      chunk = "2222222222222222222222222222222222222222222222" \
              "2222222222222222222222222222222222222222222222" \
              "22                         0000000000000000022" \
              "22                        00000000000000000 22" \
              "22                       000000000000000000 22" \
              "22                       00000000000000000  22" \
              "22                      000000000000000000  22" \
              "22                     0000000000000000000  22" \
              "22                    0000000000000000000   22" \
              "22                    0000000000000000000   22" \
              "22                   0000000000000000000    22" \
              "22                  0000000000000000000     22" \
              "22                000000000000000000000     22" \
              "22               000000000000000000000      22" \
              "22             0000000000000000000000       22" \
              "220000000000000000000000000000000000        22" \
              "220000000000000000000000000000000000        22" \
              "22000000000000000000000000000000000         22" \
              "2200000000000000000000000000000000          22" \
              "220000000000000000000000000000000           22" \
              "2200000000000000000000000000000             22" \
              "220000000000000000000000000000              22" \
              "22000000000000000000000000000              022" \
              "2200000000000000000000000000            000022" \
              "22000000000000000000000000            00000022" \
              "220000000000000000000000          000000000022" \
              "2200000000000000000000        0000000000000022" \
              "22000000000000000000      00000000000000000022" \
              "22000000000000000     000000000000000000000022" \
              "2200000000000000000000000000000000000000000022" \
              "2200000000000000000000000000000000000000000022" \
              "2200000000000000000000000000000000000000000022" \
              "2200000000000000000000000000000000000000000022" \
              "2200000000000000000000000000000000000000000022" \
              "2200000000000000000000000000000000000000000022" \
              "2200000000000000000000000000000000000000000022" \
              "2200000000000000000000000000000000000000000022"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 46),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {linear: true, uniq: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "foliage problem to solve 9" do
      #        ----------*----------
      #        0123456789012345678901
      chunk = "0000000000000000000000" \
              "0                    0" \
              "000000000000000      0" \
              "000000000000000      0" \
              "0            00      0" \
              "0       0000000      0" \
              "0       0000000      0" \
              "0                    0" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "foliage problem to solve 10" do
      #        ----------*-----------
      #        0123456789012345678901
      chunk = "      000000000       " \
              "      0   0   0       " \
              "      0   0   0       " \
              "      000000000       " \
              "         0            " \
              "      000000000       " \
              "      0  0    0       " \
              "      0  0    0       " \
              "      000000000       " \
              "          0           " \
              "      000000000       " \
              "      0  0    0       " \
              "      0  0    0       " \
              "      0  000000       " \
              "      0   0           " \
              "      0  000000       " \
              "      0  0    0       " \
              "      0  0    0       " \
              "      000000000       "

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end
  end
end
