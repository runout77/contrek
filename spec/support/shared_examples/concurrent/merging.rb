# frozen_string_literal: true

# rubocop:disable Layout/ArrayAlignment, Layout/FirstArrayElementIndentation
RSpec.shared_examples "merging" do
  describe "merging" do
    # this test demonstrate how trace contours on two different areas merging them later considering
    # they share adjacent vertical stripe (one pixel)
    it "merge mode" do
      left = "0000000000" \
              "0000000000" \
              "00        " \
              "00        " \
              "00        " \
              "00        " \
              "00        " \
              "0000000000" \
              "0000000000"
      result_left = @simple_polygon_finder.new(@bitmap_class.new(left, 10),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      right = "0000000000" \
              "0000000000" \
              "      0000" \
              "      0000" \
              "      0000" \
              "      0000" \
              "      0000" \
              "0000000000" \
              "0000000000"
      result_right = @simple_polygon_finder.new(@bitmap_class.new(right, 10),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @merger.new
      step_finder.add_tile(result_left)
      step_finder.add_tile(result_right)
      result = step_finder.process_info
      expect(result.points).to match_expected_json
    end

    it "merge mode (example 2)" do
      left = "0000000000" \
              "0000000000" \
              "00      00" \
              "00      00" \
              "0000000000" \
              "0000000000" \
              "00        " \
              "00      00" \
              "00      00" \
              "00        " \
              "0000000000" \
              "0000000000"
      result_left = @simple_polygon_finder.new(@bitmap_class.new(left, 10),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      right = "0000000000" \
              "0000000000" \
              "00    0000" \
              "00    0000" \
              "0000000000" \
              "0000000000" \
              "      0000" \
              "00    0000" \
              "00    0000" \
              "      0000" \
              "0000000000" \
              "0000000000"
      result_right = @simple_polygon_finder.new(@bitmap_class.new(right, 10),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @merger.new
      step_finder.add_tile(result_left)
      step_finder.add_tile(result_right)
      result = step_finder.process_info
      expect(result.points).to match_expected_json
    end

    it "merge mode (example 3 vertical)" do
      up = "000000000000" \
           "000000000000" \
           "000      000" \
           "000      000" \
           "000      000"
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 12),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info
      expect(result_up.metadata[:width]).to eq(12)
      expect(result_up.metadata[:height]).to eq(5)

      down = "000      000" \
             "000      000" \
             "000      000" \
             "000000000000" \
             "000000000000"
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 12),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info
      expect(result_down.metadata[:width]).to eq(12)
      expect(result_down.metadata[:height]).to eq(5)

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(12)
      expect(result.metadata[:height]).to eq(9)
      expect(result.points).to match_expected_json
    end

    it "merge mode (example 4)" do
      left = "0000" \
              "0000" \
              "0000" \
              "00  " \
              "00  " \
              "00  " \
              "00  " \
              "00  " \
              "00  " \
              "0000" \
              "0000" \
              "0000"
      result_left = @simple_polygon_finder.new(@bitmap_class.new(left, 4),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      right = "0000" \
              "0000" \
              "0000" \
              "  00" \
              "  00" \
              "  00" \
              "  00" \
              "  00" \
              "  00" \
              "0000" \
              "0000" \
              "0000"
      result_right = @simple_polygon_finder.new(@bitmap_class.new(right, 4),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @merger.new
      step_finder.add_tile(result_left)
      step_finder.add_tile(result_right)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(7)
      expect(result.metadata[:height]).to eq(12)
      expect(result.points).to match_expected_json
    end

    it "merge mode (example 5 vertical)" do
      up = "000000000000" \
           "000000000000" \
           "000      000" \
           "000      000" \
           "000      000"
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      down = "000      000" \
             "000      000" \
             "000      000" \
             "000000000000" \
             "000000000000"
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(12)
      expect(result.metadata[:height]).to eq(9)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "merge mode (example 6 vertical)" do
      up = "000000000000" \
           "000000000000" \
           "000      000" \
           "000      000"
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      mid = "000      000" \
            "000      000" \
            "000000000000" \
            "000000000000" \
            "000      000" \
            "000      000"
      result_mid = @simple_polygon_finder.new(@bitmap_class.new(mid, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      down = "000      000" \
             "000      000" \
             "000000000000" \
             "000000000000"
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_mid)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(12)
      expect(result.metadata[:height]).to eq(12)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "merge mode (example 7 vertical)" do
      up =
        "                                                                 " \
        "                       000000000000000                           " \
        "                    000000000000000000000                        " \
        "              00000000        0        000000                    " \
        "           000000             0            00000                 " \
        "         00000                00              00000              " \
        "       0000                   0                  0000            " \
        "     0000                     0                    000           " \
        "   0000                   0000000                    000         " \
        "00000               00000000000000000000               000       " \
        "000             0000000       0    00000000             000      "

      down =
        "000             0000000       0    00000000             000      " \
        "0000         000000           0          00000            000    " \
        "00000      00000              0             0000           000   " \
        "   00    0000                 0               0000          000  " \
        "    000 000                   0                 0000          00 " \
        "    00000                     00                  000         000" \
        "     00               0000000000000000              000      0000" \
        "     000          000000000      00000000            000    000  " \
        "     000      000000                  0000            00  000    " \
        "      00    00000                        0000          00000     " \
        "       00 0000                             000          000      " \
        "        0000                                 000       000       " \
        "        0000                                   000     000       " \
        "        0000                                     000000000       "

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 65),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info

      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 65),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info

      step_finder = @vertical_merger.new(options: {compress: {uniq: true, linear: true}})
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(65)
      expect(result.metadata[:height]).to eq(24)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "merge mode (example 8 preview)" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00        0       00" \
              "00        0       00" \
              "00000000000000000000" \
              "00        0       00" \
              "00        0       00" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "merge mode (example 8 vertical)" do
      up = "00000000000000000000" \
            "00000000000000000000" \
            "00        0       00"
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 20),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info

      down = "00        0       00" \
              "00        0       00" \
              "00        0       00" \
              "00000000000000000000" \
              "00000000000000000000"
      finder = @simple_polygon_finder.new(@bitmap_class.new(down, 20),
        @matcher,
        nil,
        {versus: :o, bounds: true})
      result_down = finder.process_info

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(20)
      expect(result.metadata[:height]).to eq(7)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "merge mode (example 9 vertical)" do
      up =
        "        00000000                                      0000       " \
        "       000     00                                    0000        " \
        "      000       000                                 0000       0 " \
        "     000          000                             0000 00      0 " \
        "    00000          0000                        00000    00     0 " \
        "   000  00            0000                  000000      000    0 " \
        "  000    000            00000000      000000000          000   00" \
        "0000      000              0000000000000000               00   00"
      mid =
        "0000      000              0000000000000000               00   00" \
        "000         000                  00                     00000  00" \
        " 00          0000                 0                   000  00  00" \
        "  000          0000               0                 0000    00 00" \
        "   000           0000             0              00000      00000" \
        "    000            00000          0           000000         0000" \
        "      000            000000000    0       0000000             000"

      down =
        "      000            000000000    0       0000000             000" \
        "       000               00000000000000000000               00000" \
        "         000                    0000000                   0000 00" \
        "           000                    0                     0000   00" \
        "            0000                  0                   0000     00" \
        "              00000              00                00000       00" \
        "                 00000            0             000000         0 " \
        "                    000000        0        00000000            0 " \
        "                       000000000000000000000000                0 " \
        "                           000000000000000                     0 " \
        "                                                               0 " \
        "                                                               0 "

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 65),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info

      result_mid = @simple_polygon_finder.new(@bitmap_class.new(mid, 65),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info

      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 65),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info

      step_finder = @vertical_merger.new(options: {compress: {uniq: true, linear: true}})
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_mid)
      step_finder.add_tile(result_down)

      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(65)
      expect(result.metadata[:height]).to eq(25)
      expect(result.points).to match_expected_json
    end

    it "merge mode (example 10 vertical) bug fixing" do
      up = "  0  0000       " \
              " 00000000       "
      down = " 00000000       " \
              " 000 0 00       "
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 16),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 16),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.points).to match_expected_json
    end

    it "merge mode (example 11 vertical) bug fixing" do
      up = " 000   0        " \
              "   00000        "
      down = "   00000        " \
              "     0 0        " \
              "   000          "
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 16),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 16),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info
      expect(result_down.metadata[:versus]).to eq(:a)
      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.points).to match_expected_json

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "merge mode (example 12 vertical) bug fixing" do
      up = "     00         " \
              "     00         " \
              "    00          " \
              "    00          " \
              "   00           " \
              "   00           " \
              " 0000           "
      down = " 0000           " \
              "00  0           "

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 16),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 16),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info
      expect(result_down.metadata[:versus]).to eq(:a)
      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.points).to match_expected_json

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "merge mode (example 13 vertical) bug fixing" do
      up = "  00            " \
              " 000 0          " \
              " 00000          "
      down = " 00000          " \
              "00  00          "

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 16),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 16),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info
      expect(result_down.metadata[:versus]).to eq(:a)
      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.points).to match_expected_json

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      expect(result_down.metadata[:versus]).to eq(:o)
      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "merge mode (example 14 vertical) bug fixing" do
      up = "   00000                      " \
              "    00000000000               " \
              "  000        00               " \
              "   0         00               " \
              " 00          00               " \
              " 00          00               "
      down = " 00          00               " \
              " 00          00               " \
              " 00          00               " \
              " 00000000000000               " \
              " 00000000000000               "
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 30),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 30),
        @matcher,
        nil,
        {versus: :a, bounds: true}).process_info
      expect(result_down.metadata[:versus]).to eq(:a)
      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.points).to match_expected_json

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 30),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 30),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    # This test demonstrates how join polygons by their coordinates. Youn need to build some results from scratch by
    # defining polygons each one composed by the outer polyline and a list of inners ones including its bounding box.
    # Finally you need to declare the width and the height of the whole area (tile) inside the metadata hash.
    it "merge mode from existing polygons" do
      result_up = @result.new
      polygons_up = [{
        outer: [{x: 0, y: 0}, {x: 0, y: 5}, {x: 2, y: 5}, {x: 2, y: 2}, {x: 9, y: 2},
                 {x: 9, y: 5}, {x: 11, y: 5}, {x: 11, y: 0}], inner: [],
        bounds: {min_x: 0, max_x: 11, min_y: 0, max_y: 5}
      }]
      polygons_up = @result.to_numpy(polygons_up) if result_up.is_a? Contrek::Cpp::CPPResult
      result_up.polygons = polygons_up
      result_up.metadata = {width: 12, height: 5}

      result_down = @result.new
      polygons_down = [
        {outer: [{x: 0, y: 0}, {x: 0, y: 4}, {x: 11, y: 4}, {x: 11, y: 0}, {x: 9, y: 0},
        {x: 9, y: 2}, {x: 2, y: 2}, {x: 2, y: 0}], inner: [],
         bounds: {min_x: 0, max_x: 11, min_y: 0, max_y: 4}}
]
      polygons_down = @result.to_numpy(polygons_down) if result_down.is_a? Contrek::Cpp::CPPResult
      result_down.polygons = polygons_down
      result_down.metadata = {width: 12, height: 5}

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(12)
      expect(result.metadata[:height]).to eq(9)

      expect(result.points).to match_expected_json
    end

    it "merge horizontal" do
      filename = "graphs_300x1024x0.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      color = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      rgb_matcher = @png_not_matcher.new(color.raw)
      polygonfinder = @simple_polygon_finder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}})
      left = polygonfinder.process_info

      filename = "graphs_300x1024x1.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      color = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      rgb_matcher = @png_not_matcher.new(color.raw)
      polygonfinder = @simple_polygon_finder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}})
      right = polygonfinder.process_info

      step_finder = @merger.new
      step_finder.add_tile(left)
      step_finder.add_tile(right)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(599)
      expect(result.metadata[:height]).to eq(1024)
      expect(result.points).to match_expected_polygons("graphs_599x1024", number_of_tiles: 2)
    end

    it "merge vertical" do
      filename = "graphs_1024x300x0.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      color = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      rgb_matcher = @png_not_matcher.new(color.raw)
      polygonfinder = @simple_polygon_finder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, bounds: true})
      result_up = polygonfinder.process_info

      filename = "graphs_1024x300x1.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      color = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      rgb_matcher = @png_not_matcher.new(color.raw)
      polygonfinder = @simple_polygon_finder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, bounds: true})
      result_down = polygonfinder.process_info

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(1024)
      expect(result.metadata[:height]).to eq(599)
      expect(result.points).to match_expected_polygons("graphs_1024x599", number_of_tiles: 2)
    end

    it "progressive merging on disk" do
      stripe1 = "00000000        " \
                "00000000        " \
                "00    00        " \
                "00000000  000000" \
                "00000000  000000" \
                "          00  00"
      stripe2 = "          00  00" \
                "          00  00" \
                "0000000   00  00" \
                "0000000   000000" \
                "00   00   000000" \
                "00   00         "
      stripe3 = "00   00         " \
                "00   00  0000000" \
                "00   00  0000000" \
                "00   00  00   00" \
                "00   00  00   00" \
                "00   00  0000000" \
                "00   00  0000000" \
                "00   00         "
      stripe4 = "00   00         " \
                "00   00         " \
                "00   00         " \
                "00   00         " \
                "0000000         " \
                "0000000         "
      # non streaming pattern
      stripe1_result = @simple_polygon_finder.new(@bitmap_class.new(stripe1, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      stripe2_result = @simple_polygon_finder.new(@bitmap_class.new(stripe2, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      stripe3_result = @simple_polygon_finder.new(@bitmap_class.new(stripe3, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      stripe4_result = @simple_polygon_finder.new(@bitmap_class.new(stripe4, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}).process_info
      step_finder = @vertical_merger.new(options: {compress: {uniq: true, linear: true}})
      step_finder.add_tile(stripe1_result)
      step_finder.add_tile(stripe2_result)
      step_finder.add_tile(stripe3_result)
      step_finder.add_tile(stripe4_result)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(23)
      expect(result.points).to match_expected_json(addons: [:o])

      # streaming to svg file pattern
      stripes = [stripe1, stripe2, stripe3, stripe4]
      width = result.metadata[:width]
      height = result.metadata[:height]
      shared_stream = @streaming_file.new("output.svg")
      v_merger_options = {bounds: true, compress: {uniq: true, linear: true}}
      step_finder = @svg_streaming_merger.new(
        options: v_merger_options,
        stream_to: shared_stream,
        total_width: width,
        total_height: height
      )
      stripes.each do |stripe|
        stripe_result = @simple_polygon_finder.new(@bitmap_class.new(stripe, 16),
          @matcher,
          nil,
          {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info
        last = stripes.last == stripe
        step_finder.add_tile(stripe_result, last)
      end
      result = step_finder.process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(23)
      expect(result.points).to be_empty # all polygons are on file
      shared_stream.rewind

      expect(shared_stream.read).to match_expected_stream("test_#{width}x#{height}", store_stream: true, extension: "svg", number_of_tiles: stripes.count)

      # streaming to geojson file pattern
      shared_stream = @streaming_file.new("output.geojson")
      v_merger_options = {bounds: true, compress: {uniq: true, linear: true}}
      step_finder = @geo_json_streaming_merger.new(
        options: v_merger_options,
        stream_to: shared_stream,
        pixel_val: 34
      )
      stripes.each do |stripe|
        stripe_result = @simple_polygon_finder.new(@bitmap_class.new(stripe, 16),
          @matcher,
          nil,
          {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info
        last = stripes.last == stripe
        step_finder.add_tile(stripe_result, last)
      end
      result = step_finder.process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(23)
      expect(result.points).to be_empty # all polygons are on file
      shared_stream.rewind
      expect(shared_stream.read).to match_expected_stream("test_#{width}x#{height}", store_stream: true, extension: "geojson", number_of_tiles: stripes.count)
    end
  end
end
# rubocop:enable Layout/ArrayAlignment, Layout/FirstArrayElementIndentation
