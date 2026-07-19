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
  end
end
