RSpec.shared_examples "simples" do
  describe "simple cases" do
    it "detects only one sequence" do
      chunk = "                " \
                 "      AAAA      " \
                 "                " \
                 "                " \
                 "                " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("")
      expect(result.metadata[:groups]).to eq(0)
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(7)
      expect(result.points).to eq([])
    end
    it "detects 3 blocks" do
      chunk = "AAAAAAAAAAAAAAAA" \
              "                " \
              "                " \
              "                " \
              "                " \
              "                " \
              "B              C"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("")
      expect(result.metadata[:groups]).to eq(0)
      expect(result.points).to eq([])
    end
    it "empty" do
      chunk = "                " \
                 "                " \
                 "                " \
                 "                " \
                 "                " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("")
      expect(result.metadata[:groups]).to eq(0)
      expect(result.points).to eq([])
    end
    it "is full", is_full: true do
      chunk = "AAAAAAAAAAAAAAAA" \
                 "BBBBBBBBBBBBBBBB" \
                 "CCCCCCCCCCCCCCCC" \
                 "DDDDDDDDDDDDDDDD" \
                 "EEEEEEEEEEEEEEEE" \
                 "FFFFFFFFFFFFFFFF" \
                 "GGGGGGGGGGGGGGGG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6}, {x: 15, y: 6}, {x: 15, y: 5}, {x: 15, y: 4}, {x: 15, y: 3}, {x: 15, y: 2}, {x: 15, y: 1}, {x: 15, y: 0}],
         inner: []}
      ])
    end
    it "is full ask for compression", test_compression: true do
      chunk = "AAAAAAAAAAAAAAAA" \
                 "BBBBBBBBBBBBBBBB" \
                 "CCCCCCCCCCCCCCCC" \
                 "DDDDDDDDDDDDDDDD" \
                 "EEEEEEEEEEEEEEEE" \
                 "FFFFFFFFFFFFFFFF" \
                 "GGGGGGGGGGGGGGGG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true, compress: {linear: true}}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 6}, {x: 15, y: 6}, {x: 15, y: 0}],
         inner: []}
      ])
    end

    it "problem", test_problem: true do
      chunk = "  AAAAAAAAAAAA  " \
                " BB  MMMMMMMMMM " \
                " CC  LL       N " \
                " DDDDDD   SS  O " \
                " EE   II  RR  P " \
                "  FF  HHH    QQ " \
                "   GGGGGGGGGGG  "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGQPONMA-SRS")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to eq(
        [{outer: [{x: 2, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 2, y: 5}, {x: 3, y: 6}, {x: 13, y: 6}, {x: 14, y: 5}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 13, y: 0}],
          inner: [
            [{x: 2, y: 1}, {x: 5, y: 1}, {x: 5, y: 2}, {x: 2, y: 2}],
            [{x: 2, y: 4}, {x: 6, y: 4}, {x: 6, y: 5}, {x: 3, y: 5}],
            [{x: 13, y: 5}, {x: 8, y: 5}, {x: 7, y: 4}, {x: 6, y: 3}, {x: 6, y: 2}, {x: 14, y: 2}, {x: 14, y: 3}, {x: 14, y: 4}]

          ]},
          {outer: [{x: 10, y: 3}, {x: 10, y: 4}, {x: 11, y: 4}, {x: 11, y: 3}],
           inner: []}]
      )
    end

    it "problem 2", test_problem2: true do
      chunk = "  AAAAAAAAAAAA  " \
                " BB  MMMMMMMMMM " \
                " CC  LLLLLLLLLL " \
                " DDDDDDDDDDDDDD " \
                " EEEEEEEEEEEEEE " \
                " FFFFFFF      F " \
                " NNNNNNNN  RR N " \
                " PPPPPPPP  SS P " \
                " QQQQQQQQ     Q " \
                " GGGGGGGGGGGGGG " \
                " HH   IIIIIIIII " \
                "  LL  LLLLLLLLL " \
                "   MMMMMMMMMMMM "
      pf = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true})
      result = pf.process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFNPQGHLMLIGQPNFEDLMA-RSR")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to eq([{outer: [{x: 2, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 1, y: 5}, {x: 1, y: 6}, {x: 1, y: 7}, {x: 1, y: 8}, {x: 1, y: 9}, {x: 1, y: 10}, {x: 2, y: 11}, {x: 3, y: 12}, {x: 14, y: 12}, {x: 14, y: 11}, {x: 14, y: 10}, {x: 14, y: 9}, {x: 14, y: 8}, {x: 14, y: 7}, {x: 14, y: 6}, {x: 14, y: 5}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 13, y: 0}], inner: [[{x: 2, y: 1}, {x: 5, y: 1}, {x: 5, y: 2}, {x: 2, y: 2}], [{x: 7, y: 5}, {x: 14, y: 5}, {x: 14, y: 6}, {x: 14, y: 7}, {x: 14, y: 8}, {x: 8, y: 8}, {x: 8, y: 7}, {x: 8, y: 6}], [{x: 2, y: 10}, {x: 6, y: 10}, {x: 6, y: 11}, {x: 3, y: 11}]]}, {outer: [{x: 11, y: 6}, {x: 11, y: 7}, {x: 12, y: 7}, {x: 12, y: 6}], inner: []}])
    end

    it "is full ask for compression and scale coords", test_compression_scale: true do
      chunk = "AAAAAAAAAAAAAAAA" \
                 "BBBBBBBBBBBBBBBB" \
                 "CCCCCCCCCCCCCCCC" \
                 "DDDDDDDDDDDDDDDD" \
                 "EEEEEEEEEEEEEEEE" \
                 "FFFFFFFFFFFFFFFF" \
                 "GGGGGGGGGGGGGGGG"
      pf = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true, compress: {linear: true}})
      result = pf.process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 6}, {x: 15, y: 6}, {x: 15, y: 0}],
         inner: []}
      ])
    end

    it "is triangle full" do
      chunk = "AAAAAAA         " \
                 "BBBBBB          " \
                 "CCCCC           " \
                 "DDDD            " \
                 "EEE             " \
                 "FF              " \
                 "G               "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6}, {x: 0, y: 6}, {x: 1, y: 5}, {x: 2, y: 4}, {x: 3, y: 3}, {x: 4, y: 2}, {x: 5, y: 1}, {x: 6, y: 0}],
         inner: []}
      ])
    end

    it "is triangle full with compression", tcompression: true do
      chunk = "AAAAAAA         " \
                 "BBBBBB          " \
                 "CCCCC           " \
                 "DDDD            " \
                 "EEE             " \
                 "FF              " \
                 "G               "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 6}, {x: 6, y: 0}],
         inner: []}
      ])
    end

    it "find a rectangle" do
      chunk = "                " \
                 "      AA        " \
                 "      BB        " \
                 "      CC        " \
                 "      DD        " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 6, y: 1}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 6, y: 4}, {x: 7, y: 4}, {x: 7, y: 3}, {x: 7, y: 2}, {x: 7, y: 1}],
         inner: []}
      ])
    end

    it "find a shape with single top pixel" do
      chunk = "                " \
                 "      A         " \
                 "      BB        " \
                 "      CC        " \
                 "      DD        " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 6, y: 1}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 6, y: 4}, {x: 7, y: 4}, {x: 7, y: 3}, {x: 7, y: 2}, {x: 6, y: 1}],
         inner: []}
      ])
    end

    it "find a rectangle clockwise" do
      chunk = "                " \
                 "      AA        " \
                 "      BB        " \
                 "      CC        " \
                 "      DD        " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 6, y: 1}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 6, y: 4}, {x: 7, y: 4}, {x: 7, y: 3}, {x: 7, y: 2}, {x: 7, y: 1}].reverse,
         inner: []}
      ])
    end
    it "finds two blocks but only one polygon", i_alone: true do
      chunk = "  AAAAAAAAAAAA  " \
                 "  H          B  " \
                 "  G   III    C  " \
                 "  F          D  " \
                 "  EEEEEEEEEEEE  " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 2, y: 0}, {x: 2, y: 1}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 13, y: 0}],
         inner: [[{x: 2, y: 1}, {x: 13, y: 1}, {x: 13, y: 2}, {x: 13, y: 3}, {x: 2, y: 3}, {x: 2, y: 2}]]}
      ])
    end
    it "finds two blocks but only one polygon clockwise" do
      chunk = "  AAAAAAAAAAAA  " \
                 "  HH        BB  " \
                 "  GG  III   CC  " \
                 "  FF        DD  " \
                 "  EEEEEEEEEEEE  " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 2, y: 0}, {x: 2, y: 1}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 13, y: 0}],
         inner: [[{x: 3, y: 1}, {x: 12, y: 1}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 3, y: 3}, {x: 3, y: 2}]]}
      ])
    end
    it "finds one polygon ignores I and L", ignore_il: true do
      chunk = "  AAAAAAAAAAAA  " \
                 "  H          B  " \
                 "  G   III    C  " \
                 "  F   LLL    D  " \
                 "  EEEEEEEEEEEE  " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 2, y: 0}, {x: 2, y: 1}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 13, y: 0}],
         inner: [[{x: 2, y: 1}, {x: 13, y: 1}, {x: 13, y: 2}, {x: 13, y: 3}, {x: 8, y: 3}, {x: 8, y: 2}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 2, y: 3}, {x: 2, y: 2}]]}
      ])
    end
    it "finds three blocks two polygons", tbtp: true do
      chunk = "                " \
                 "   AAAA   CCCC  " \
                 "   BBBB   DDDD  " \
                 "                " \
                 "                " \
                 "       EEE      " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA-CDC")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
         inner: []},
        {outer: [{x: 10, y: 1}, {x: 10, y: 2}, {x: 13, y: 2}, {x: 13, y: 1}],
         inner: []}
      ])
    end
  end
end
