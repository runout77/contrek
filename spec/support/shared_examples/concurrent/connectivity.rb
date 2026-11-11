# frozen_string_literal: true

RSpec.shared_examples "connectivity" do
  describe "connectivity" do
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
      expect(result.points).to match_expected_json
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
        options: {bounds: true, number_of_tiles: 2, versus: :o, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
    end

    it "problematic case" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00000             00" \
              "00000             00" \
              "00000             00" \
              "00000000000000000000" \
              "00000000000000000000" \
              "00000000000000000000" \
              "00000     0000000000" \
              "00000     0000000000" \
              "00000     0000000000" \
              "0000000000        00" \
              "0000000000        00" \
              "0000000000        00" \
              "00000     0000000000" \
              "00000     0000000000" \
              "00000     0000000000" \
              "00000000000000000000" \
              "00000000000000000000" \
              "00000000000000000000"

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    # The polygon in tile 1, the right one, has a SEAM part repeated ([9,13][9,12][9,11] and [9,11][9,12][9,13]).
    # The algorith when do not consider the versus in join_inners() keeps (anti clockwise) the first one (position 2)
    # instead of the 6th the right one.
    it "problematic case 2 (scorpion's revenge)" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00000             00" \
              "00000             00" \
              "00000             00" \
              "0000000000000000  00" \
              "0000000000000000  00" \
              "0000000000000000  00" \
              "00000     000000  00" \
              "00000     000000  00" \
              "00000     000000  00" \
              "0000000000        00" \
              "0000000000        00" \
              "0000000000        00" \
              "00000     0000000000" \
              "00000     0000000000" \
              "00000     0000000000" \
              "00000000000000000000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "problematic case 3" do
      #        ---------*----------
      chunk = "0000                " \
              "00000               " \
              "000000              " \
              "0000000000          " \
              "0000000000          " \
              "00        000000    " \
              "00        000000    " \
              "00        000000    " \
              "0000000000          " \
              "0000000000          " \
              "0000000000          "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "problematic case 4" do
      #          ---------*----------
      chunk = "                0000" \
                "               00000" \
                "              000000" \
                "         00000000000" \
                "         00000000000" \
                "    00000         00" \
                "    00000         00" \
                "    00000         00" \
                "         00000000000" \
                "         00000000000" \
                "         00000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, connectivity: 8, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "problematic case 5" do
      chunk =
        "                    " \
        "  222  22222        " \
        "22   22     22      " \
        "  222  22222        " \
        "22   222   2        " \
        "  2222222222        " \
        "     22     22      " \
        "       22222        " \
        "                    "
      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 20),
        @matcher,
        nil,
        {connectivity: 8, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json
    end

    it "problematic case 6" do
      chunk = [
        # 0123456789012345678901234567890123456789
        "C000000000000000000000000000000000000000",
        "B00000000000000000000000000000 100000000",
        "A0000000000000000000000000000 z000000000",
        "D000000000000000000000   y00000000000000",
        "i0000000000000 %0000  l     x00000000000",
        "a000   h000000 I000 m000   u00 200000000",
        "b00 e g000000   #    n00  v0000 30000000",
        "c0 f00000000         &    t 400000000000",
        "d0000000000 o0  p00    s0000000000000000",
        "r0000000000000  q00000000000000000000000",
        "Y000000000000000000000000000000000000000"
      ].join
      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 40),
        @matcher,
        nil,
        {connectivity: 8, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json
    end
  end
end
