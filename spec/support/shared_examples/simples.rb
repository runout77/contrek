RSpec.shared_examples "simples" do
  describe "simple cases" do
    it "detects only one sequence" do
      chunk = "0000000000000000" \
                 "000000AAAA000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("A")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([])
    end
    it "detects 3 blocks" do
      chunk = "AAAAAAAAAAAAAAAA" \
              "0000000000000000" \
              "0000000000000000" \
              "0000000000000000" \
              "0000000000000000" \
              "0000000000000000" \
              "B00000000000000C"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("A-B-C")
      expect(result.metadata[:groups]).to eq(3)
      expect(result.points).to eq([])
    end
    it "empty" do
      chunk = "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000"
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
      chunk = "00AAAAAAAAAAAA00" \
                "0BB00MMMMMMMMMM0" \
                "0CC00LL0000000N0" \
                "0DDDDDD000SS00O0" \
                "0EE000II00RR00P0" \
                "00FF00HHH0000QQ0" \
                "000GGGGGGGGGGG00"
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
      chunk = "00AAAAAAAAAAAA00" \
                "0BB00MMMMMMMMMM0" \
                "0CC00LLLLLLLLLL0" \
                "0DDDDDDDDDDDDDD0" \
                "0EEEEEEEEEEEEEE0" \
                "0FFFFFFF000000F0" \
                "0NNNNNNNN00RR0N0" \
                "0PPPPPPPP00SS0P0" \
                "0QQQQQQQQ00000Q0" \
                "0GGGGGGGGGGGGGG0" \
                "0HH000IIIIIIIII0" \
                "00LL00LLLLLLLLL0" \
                "000MMMMMMMMMMMM0"
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
      chunk = "AAAAAAA000000000" \
                 "BBBBBB0000000000" \
                 "CCCCC00000000000" \
                 "DDDD000000000000" \
                 "EEE0000000000000" \
                 "FF00000000000000" \
                 "G000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6}, {x: 0, y: 6}, {x: 1, y: 5}, {x: 2, y: 4}, {x: 3, y: 3}, {x: 4, y: 2}, {x: 5, y: 1}, {x: 6, y: 0}],
         inner: []}
      ])
    end

    it "is triangle full with compression", tcompression: true do
      chunk = "AAAAAAA000000000" \
                 "BBBBBB0000000000" \
                 "CCCCC00000000000" \
                 "DDDD000000000000" \
                 "EEE0000000000000" \
                 "FF00000000000000" \
                 "G000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 6}, {x: 6, y: 0}],
         inner: []}
      ])
    end

    it "find a rectangle" do
      chunk = "0000000000000000" \
                 "000000AA00000000" \
                 "000000BB00000000" \
                 "000000CC00000000" \
                 "000000DD00000000" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 6, y: 1}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 6, y: 4}, {x: 7, y: 4}, {x: 7, y: 3}, {x: 7, y: 2}, {x: 7, y: 1}],
         inner: []}
      ])
    end
    it "find a rectangle clockwise" do
      chunk = "0000000000000000" \
                 "000000AA00000000" \
                 "000000BB00000000" \
                 "000000CC00000000" \
                 "000000DD00000000" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 6, y: 1}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 6, y: 4}, {x: 7, y: 4}, {x: 7, y: 3}, {x: 7, y: 2}, {x: 7, y: 1}].reverse,
         inner: []}
      ])
    end
    it "finds two blocks but only one polygon", i_alone: true do
      chunk = "00AAAAAAAAAAAA00" \
                 "00H0000000000B00" \
                 "00G000III0000C00" \
                 "00F0000000000D00" \
                 "00EEEEEEEEEEEE00" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AHGFEDCBA-I")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to eq([
        {outer: [{x: 2, y: 0}, {x: 2, y: 1}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 13, y: 0}],
         inner: [[{x: 2, y: 1}, {x: 13, y: 1}, {x: 13, y: 2}, {x: 13, y: 3}, {x: 2, y: 3}, {x: 2, y: 2}]]}
      ])
    end
    it "finds two blocks but only one polygon clockwise" do
      chunk = "00AAAAAAAAAAAA00" \
                 "00HH00000000BB00" \
                 "00GG00III000CC00" \
                 "00FF00000000DD00" \
                 "00EEEEEEEEEEEE00" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AHGFEDCBA-I")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to eq([
        {outer: [{x: 2, y: 0}, {x: 2, y: 1}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 13, y: 0}],
         inner: [[{x: 3, y: 1}, {x: 12, y: 1}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 3, y: 3}, {x: 3, y: 2}]]}
      ])
    end
    it "finds one polygon ignores I and L", ignore_il: true do
      chunk = "00AAAAAAAAAAAA00" \
                 "00H0000000000B00" \
                 "00G000III0000C00" \
                 "00F000LLL0000D00" \
                 "00EEEEEEEEEEEE00" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 2, y: 0}, {x: 2, y: 1}, {x: 2, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 13, y: 0}],
         inner: [[{x: 2, y: 1}, {x: 13, y: 1}, {x: 13, y: 2}, {x: 13, y: 3}, {x: 8, y: 3}, {x: 8, y: 2}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 2, y: 3}, {x: 2, y: 2}]]}
      ])
    end
    it "finds three blocks two polygons", tbtp: true do
      chunk = "0000000000000000" \
                 "000AAAA000CCCC00" \
                 "000BBBB000DDDD00" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "0000000EEE000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA-CDC-E")
      expect(result.metadata[:groups]).to eq(3)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
         inner: []},
        {outer: [{x: 10, y: 1}, {x: 10, y: 2}, {x: 13, y: 2}, {x: 13, y: 1}],
         inner: []}
      ])
    end
  end
end
