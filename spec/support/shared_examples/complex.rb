require "yaml"
RSpec.shared_examples "complex" do
  describe "simple cases" do
    it "faster indexing", faster_indexing: true do
      chunk = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" \
               "A0B0C0D0E0F0G0H0I0J0K0L0M0N0O0P0Q0R0S0T0U0V0W0X0Y0A0B0C0D0E0F0G0H0I0J0K0L0M0N0O0P0Q0R0S0T0U0V0W0X0Y0A0B0C0D0E0F0G0H0I0J0K0L0M0N0O0P0Q0R0S0T0U0V0W0X0Y0A0B0C0D0E0F0G0H0I0J0K0L0M0N0O0P0Q0R0S0T0U0V0W0X0Y0" \
               "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" \
               "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 200), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZAZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZAZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZAZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 1}, {x: 0, y: 2}, {x: 199, y: 2}, {x: 198, y: 1}, {x: 198, y: 1}, {x: 196, y: 1}, {x: 196, y: 1}, {x: 194, y: 1}, {x: 194, y: 1}, {x: 192, y: 1}, {x: 192, y: 1}, {x: 190, y: 1}, {x: 190, y: 1}, {x: 188, y: 1}, {x: 188, y: 1}, {x: 186, y: 1}, {x: 186, y: 1}, {x: 184, y: 1}, {x: 184, y: 1}, {x: 182, y: 1}, {x: 182, y: 1}, {x: 180, y: 1}, {x: 180, y: 1}, {x: 178, y: 1}, {x: 178, y: 1}, {x: 176, y: 1}, {x: 176, y: 1}, {x: 174, y: 1}, {x: 174, y: 1}, {x: 172, y: 1}, {x: 172, y: 1}, {x: 170, y: 1}, {x: 170, y: 1}, {x: 168, y: 1}, {x: 168, y: 1}, {x: 166, y: 1}, {x: 166, y: 1}, {x: 164, y: 1}, {x: 164, y: 1}, {x: 162, y: 1}, {x: 162, y: 1}, {x: 160, y: 1}, {x: 160, y: 1}, {x: 158, y: 1}, {x: 158, y: 1}, {x: 156, y: 1}, {x: 156, y: 1}, {x: 154, y: 1}, {x: 154, y: 1}, {x: 152, y: 1}, {x: 152, y: 1}, {x: 150, y: 1}, {x: 150, y: 1}, {x: 148, y: 1}, {x: 148, y: 1}, {x: 146, y: 1}, {x: 146, y: 1}, {x: 144, y: 1}, {x: 144, y: 1}, {x: 142, y: 1}, {x: 142, y: 1}, {x: 140, y: 1}, {x: 140, y: 1}, {x: 138, y: 1}, {x: 138, y: 1}, {x: 136, y: 1}, {x: 136, y: 1}, {x: 134, y: 1}, {x: 134, y: 1}, {x: 132, y: 1}, {x: 132, y: 1}, {x: 130, y: 1}, {x: 130, y: 1}, {x: 128, y: 1}, {x: 128, y: 1}, {x: 126, y: 1}, {x: 126, y: 1}, {x: 124, y: 1}, {x: 124, y: 1}, {x: 122, y: 1}, {x: 122, y: 1}, {x: 120, y: 1}, {x: 120, y: 1}, {x: 118, y: 1}, {x: 118, y: 1}, {x: 116, y: 1}, {x: 116, y: 1}, {x: 114, y: 1}, {x: 114, y: 1}, {x: 112, y: 1}, {x: 112, y: 1}, {x: 110, y: 1}, {x: 110, y: 1}, {x: 108, y: 1}, {x: 108, y: 1}, {x: 106, y: 1}, {x: 106, y: 1}, {x: 104, y: 1}, {x: 104, y: 1}, {x: 102, y: 1}, {x: 102, y: 1}, {x: 100, y: 1}, {x: 100, y: 1}, {x: 98, y: 1}, {x: 98, y: 1}, {x: 96, y: 1}, {x: 96, y: 1}, {x: 94, y: 1}, {x: 94, y: 1}, {x: 92, y: 1}, {x: 92, y: 1}, {x: 90, y: 1}, {x: 90, y: 1}, {x: 88, y: 1}, {x: 88, y: 1}, {x: 86, y: 1}, {x: 86, y: 1}, {x: 84, y: 1}, {x: 84, y: 1}, {x: 82, y: 1}, {x: 82, y: 1}, {x: 80, y: 1}, {x: 80, y: 1}, {x: 78, y: 1}, {x: 78, y: 1}, {x: 76, y: 1}, {x: 76, y: 1}, {x: 74, y: 1}, {x: 74, y: 1}, {x: 72, y: 1}, {x: 72, y: 1}, {x: 70, y: 1}, {x: 70, y: 1}, {x: 68, y: 1}, {x: 68, y: 1}, {x: 66, y: 1}, {x: 66, y: 1}, {x: 64, y: 1}, {x: 64, y: 1}, {x: 62, y: 1}, {x: 62, y: 1}, {x: 60, y: 1}, {x: 60, y: 1}, {x: 58, y: 1}, {x: 58, y: 1}, {x: 56, y: 1}, {x: 56, y: 1}, {x: 54, y: 1}, {x: 54, y: 1}, {x: 52, y: 1}, {x: 52, y: 1}, {x: 50, y: 1}, {x: 50, y: 1}, {x: 48, y: 1}, {x: 48, y: 1}, {x: 46, y: 1}, {x: 46, y: 1}, {x: 44, y: 1}, {x: 44, y: 1}, {x: 42, y: 1}, {x: 42, y: 1}, {x: 40, y: 1}, {x: 40, y: 1}, {x: 38, y: 1}, {x: 38, y: 1}, {x: 36, y: 1}, {x: 36, y: 1}, {x: 34, y: 1}, {x: 34, y: 1}, {x: 32, y: 1}, {x: 32, y: 1}, {x: 30, y: 1}, {x: 30, y: 1}, {x: 28, y: 1}, {x: 28, y: 1}, {x: 26, y: 1}, {x: 26, y: 1}, {x: 24, y: 1}, {x: 24, y: 1}, {x: 22, y: 1}, {x: 22, y: 1}, {x: 20, y: 1}, {x: 20, y: 1}, {x: 18, y: 1}, {x: 18, y: 1}, {x: 16, y: 1}, {x: 16, y: 1}, {x: 14, y: 1}, {x: 14, y: 1}, {x: 12, y: 1}, {x: 12, y: 1}, {x: 10, y: 1}, {x: 10, y: 1}, {x: 8, y: 1}, {x: 8, y: 1}, {x: 6, y: 1}, {x: 6, y: 1}, {x: 4, y: 1}, {x: 4, y: 1}, {x: 2, y: 1}, {x: 2, y: 1}, {x: 0, y: 1}], inner: []}])
    end
    it "scan complex tree", complex_tree: true do
      chunk = "0000000000000000" \
               "0000AAAAAAAA0000" \
               "000BBB0000II0000" \
               "00CC00HH0LLL0000" \
               "0DDDD0GG00000000" \
               "00EEEEEE00000000" \
               "000FF00000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEGHGEDCBAILIA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 4, y: 1}, {x: 3, y: 2}, {x: 2, y: 3}, {x: 1, y: 4}, {x: 2, y: 5}, {x: 3, y: 6}, {x: 4, y: 6}, {x: 7, y: 5}, {x: 7, y: 4}, {x: 7, y: 3}, {x: 6, y: 3}, {x: 6, y: 4}, {x: 4, y: 4}, {x: 3, y: 3}, {x: 5, y: 2}, {x: 10, y: 2}, {x: 9, y: 3}, {x: 11, y: 3}, {x: 11, y: 2}, {x: 11, y: 1}],
         inner: []}
      ])
    end
    it "scan U polygon" do
      chunk = "0000000000000000" \
                  "000AAAA000EEEE00" \
                  "000BBBB000DDDD00" \
                  "000CCCCCCCCCCC00" \
                  "0000000000000000" \
                  "0000000000000000" \
                  "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
         inner: []}
      ])
    end
    it "scan U polygon clockwise" do
      chunk = "0000000000000000" \
                  "000AAAA000EEEE00" \
                  "000BBBB000DDDD00" \
                  "000CCCCCCCCCCC00" \
                  "0000000000000000" \
                  "0000000000000000" \
                  "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}].reverse,
         inner: []}
      ])
    end
    it "scan U polygon wider baseline" do
      chunk = "0000000000000000" \
                 "000AAAA000FFFF00" \
                 "000BBBB000EEEE00" \
                 "000CCCCCCCCCCC00" \
                 "000DDDDDDDDDDD00" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCEFECBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
         inner: []}
      ])
    end
    it "scan N polygon" do
      chunk = "0000000000000000" \
               "000AAAAAAAAAAA00" \
               "000BBBB000DDDD00" \
               "000CCCC000EEEE00" \
               "0000000000000000" \
               "0000000000000000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCBADEDA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 6, y: 3}, {x: 6, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}],
                                    inner: []}])
    end
    it "scan N polygon clockwise" do
      chunk = "0000000000000000" \
               "000AAAAAAAAAAA00" \
               "000BBBB000DDDD00" \
               "000CCCC000EEEE00" \
               "0000000000000000" \
               "0000000000000000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ADEDABCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 6, y: 3}, {x: 6, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}].reverse,
                                    inner: []}])
    end
    it "scans holed polygon" do
      chunk = "0000000000000000" \
                 "000000AAA0000000" \
                 "00000BB0DDD00000" \
                 "000000CCC0000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 6, y: 1}, {x: 5, y: 2}, {x: 6, y: 3}, {x: 8, y: 3}, {x: 10, y: 2}, {x: 8, y: 1}], inner: [[{x: 6, y: 2}, {x: 8, y: 2}]]}])
    end
    it "scans holed polygon 2" do
      chunk = "0000000000000000" \
                 "000AAAAAAAAAAA00" \
                 "000BBBB000HHHH00" \
                 "000CCC00000GG000" \
                 "00DDDD00FFFFF000" \
                 "0000EEEEEEEE0000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 2, y: 4}, {x: 4, y: 5}, {x: 11, y: 5}, {x: 12, y: 4}, {x: 12, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}],
                                    inner: [[{x: 6, y: 2}, {x: 10, y: 2}, {x: 11, y: 3}, {x: 8, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}]]}])
    end
    it "scan sequence" do
      chunk = "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "00AAAAAA00000E00" \
                 "0000BBBBB0000DD0" \
                 "0000000CCCCCCC00" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 2, y: 3}, {x: 4, y: 4}, {x: 7, y: 5}, {x: 13, y: 5}, {x: 14, y: 4}, {x: 13, y: 3}, {x: 13, y: 3}, {x: 13, y: 4}, {x: 8, y: 4}, {x: 7, y: 3}],
         inner: []}
      ])
    end
    it "scan an opened polygon" do
      chunk = "0000000000000000" \
                 "0000000000000000" \
                 "0000000000000000" \
                 "00AAAAAA00000F00" \
                 "0000BBBBB0000EE0" \
                 "0000000CCCCCCC00" \
                 "00000000DDDDD000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCEFECBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 2, y: 3}, {x: 4, y: 4}, {x: 7, y: 5}, {x: 8, y: 6}, {x: 12, y: 6}, {x: 13, y: 5}, {x: 14, y: 4}, {x: 13, y: 3}, {x: 13, y: 3}, {x: 13, y: 4}, {x: 8, y: 4}, {x: 7, y: 3}],
                                    inner: []}])
    end
    it "scans M polygon" do
      chunk = "0000000000000000" \
                "000AAAAAAAAAAAA0" \
                "000B00C00000D000" \
                "0000000000000000" \
                "0000000000000000" \
                "0000000000000000" \
                "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABACADA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 2}, {x: 6, y: 2}, {x: 6, y: 2}, {x: 12, y: 2}, {x: 12, y: 2}, {x: 14, y: 1}],
         inner: []}
      ])
    end
    it "scans W poligon" do
      chunk = "0000000000000000" \
                "000A000C0000D000" \
                "000BBBBBBBBBB000" \
                "0000000000000000" \
                "0000000000000000" \
                "0000000000000000" \
                "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABDBCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 12, y: 2}, {x: 12, y: 1}, {x: 12, y: 1}, {x: 7, y: 1}, {x: 7, y: 1}, {x: 3, y: 1}],
                                    inner: []}])
    end
    it "scan W inverted polygon" do
      chunk = "0000000000000000" \
                "0000000000000000" \
                "000B00C00000D000" \
                "000AAAAAAAAAAAA0" \
                "00000000000000E0" \
                "0000000000000000" \
                "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("BAEADACAB")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 2}, {x: 3, y: 3}, {x: 14, y: 4}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 12, y: 2}, {x: 12, y: 2}, {x: 6, y: 2}, {x: 6, y: 2}, {x: 3, y: 2}],
                                    inner: []}])
    end
    it "scans N polygon" do
      chunk = "0000000000000000" \
                 "000000000000AA00" \
                 "0000FFFFFF00BB00" \
                 "0000GG00EE00CC00" \
                 "0000HH00DDDDDD00" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 12, y: 1}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 9, y: 3}, {x: 9, y: 2}, {x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 8, y: 3}, {x: 8, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}],
                                    inner: []}])
    end
    it "scans N polygon clockwise" do
      chunk = "0000000000000000" \
                 "000000000000AA00" \
                 "0000FFFFFF00BB00" \
                 "0000GG00EE00CC00" \
                 "0000HH00DDDDDD00" \
                 "0000000000000000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 12, y: 1}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 9, y: 3}, {x: 9, y: 2}, {x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 8, y: 3}, {x: 8, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}].reverse,
                                    inner: []}])
    end
    it "scans N polygon other root node" do
      chunk = "0000000000000000" \
               "0000000000000000" \
               "0000AAAAAA00GG00" \
               "0000BB00DD00FF00" \
               "0000CC00EEEEEE00" \
               "0000000000000000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCBADEFGFEDA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 8, y: 3}, {x: 8, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 9, y: 3}, {x: 9, y: 2}],
                                    inner: []}])
    end
    it "scan snake" do
      chunk = "0000000000000000" \
               "0000000000000A00" \
               "000P0LLL0FFF0B00" \
               "000O0M0I0G0E0C00" \
               "000NNN0HHH0DDD00" \
               "0000000000000000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHILMNOPONMLIHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 13, y: 1}, {x: 13, y: 2}, {x: 13, y: 3}, {x: 11, y: 3}, {x: 11, y: 2}, {x: 9, y: 2}, {x: 9, y: 3}, {x: 7, y: 3}, {x: 7, y: 2}, {x: 5, y: 2}, {x: 5, y: 3}, {x: 3, y: 3}, {x: 3, y: 2}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 7, y: 3}, {x: 7, y: 4}, {x: 9, y: 4}, {x: 9, y: 3}, {x: 11, y: 3}, {x: 11, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}],
                                    inner: []}])
    end
    it "scan complex" do
      chunk = "000000000000000A" \
              "NNNNNNNNNNNNNN0B" \
              "M000000000000O0C" \
              "L0R0000000000P0D" \
              "I0QQQQQQQQQQQQ0E" \
              "H00000000000000F" \
              "GGGGGGGGGGGGGGGG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHILMNOPQRQPONMLIHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 15, y: 0}, {x: 15, y: 1}, {x: 15, y: 2}, {x: 15, y: 3}, {x: 15, y: 4}, {x: 15, y: 5}, {x: 0, y: 5}, {x: 0, y: 4}, {x: 0, y: 3}, {x: 0, y: 2}, {x: 13, y: 2}, {x: 13, y: 3}, {x: 2, y: 3}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6}, {x: 15, y: 6}, {x: 15, y: 5}, {x: 15, y: 4}, {x: 15, y: 3}, {x: 15, y: 2}, {x: 15, y: 1}, {x: 15, y: 0}],
                                    inner: []}])
    end
    it "scan open sequence" do
      chunk = "AAAAAAAAA0000000" \
               "00000000BBB00000" \
               "0000000000CCCC00" \
               "000FFFF000DDDD00" \
               "000EEEEEEEEEEE00" \
               "0000000000000000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 8, y: 1}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 6, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 10, y: 1}, {x: 8, y: 0}],
                                    inner: []}])
    end
    it "scan open sequence clockwise" do
      chunk = "AAAAAAAAA0000000" \
               "00000000BBB00000" \
               "0000000000CCCC00" \
               "000FFFF000DDDD00" \
               "000EEEEEEEEEEE00" \
               "0000000000000000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 8, y: 1}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 6, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 10, y: 1}, {x: 8, y: 0}].reverse,
                                    inner: []}])
    end
    it "scan inverse two times" do
      chunk = "0000000000000000" \
               "0000000000000000" \
               "0000000000AAAA00" \
               "000DDDD000BBBB00" \
               "000CCCCCCCCCCC00" \
               "0000000000000000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 10, y: 2}, {x: 10, y: 3}, {x: 6, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}],
                                    inner: []}])
    end
    it "case A" do
      chunk = "AA00000000000000" \
                 "0BB0000000000000" \
                 "00CC000000000000" \
                 "000DDDDDDDDDD000" \
                 "000000000000EE00" \
                 "0000000000000FF0" \
                 "00000000000000GG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 1, y: 1}, {x: 2, y: 2}, {x: 3, y: 3}, {x: 12, y: 4}, {x: 13, y: 5}, {x: 14, y: 6}, {x: 15, y: 6}, {x: 14, y: 5}, {x: 13, y: 4}, {x: 12, y: 3}, {x: 3, y: 2}, {x: 2, y: 1}, {x: 1, y: 0}],
                                    inner: []}])
    end
    it "case B arrow" do
      chunk = "00000000000000AA" \
                 "0000000000000BB0" \
                 "000000000000CC00" \
                 "DDDDDDDDDDDDD000" \
                 "000000000000EE00" \
                 "0000000000000FF0" \
                 "00000000000000GG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 14, y: 0}, {x: 13, y: 1}, {x: 12, y: 2}, {x: 0, y: 3}, {x: 12, y: 4}, {x: 13, y: 5}, {x: 14, y: 6}, {x: 15, y: 6}, {x: 14, y: 5}, {x: 13, y: 4}, {x: 12, y: 3}, {x: 13, y: 2}, {x: 14, y: 1}, {x: 15, y: 0}],
                                    inner: []}])
    end
    it "scans V inverted" do
      chunk = "0000000000000000" \
                 "0000000AAA000000" \
                 "00000BBBBBB00000" \
                 "000CCCC00FFFFFFF" \
                 "00DDDD00000GGG00" \
                 "000EE0000000H000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCBFGHGFBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 7, y: 1}, {x: 5, y: 2}, {x: 3, y: 3}, {x: 2, y: 4}, {x: 3, y: 5}, {x: 4, y: 5}, {x: 5, y: 4}, {x: 6, y: 3}, {x: 9, y: 3}, {x: 11, y: 4}, {x: 12, y: 5}, {x: 12, y: 5}, {x: 13, y: 4}, {x: 15, y: 3}, {x: 10, y: 2}, {x: 9, y: 1}],
                                    inner: []}])
    end
    it "scans V inverted clockwise" do
      chunk = "0000000000000000" \
                 "0000000AAA000000" \
                 "00000BBBBBB00000" \
                 "000CCCC00FFFFFFF" \
                 "00DDDD00000GGG00" \
                 "000EE0000000H000" \
                 "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABFGHGFBCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 7, y: 1}, {x: 5, y: 2}, {x: 3, y: 3}, {x: 2, y: 4}, {x: 3, y: 5}, {x: 4, y: 5}, {x: 5, y: 4}, {x: 6, y: 3}, {x: 9, y: 3}, {x: 11, y: 4}, {x: 12, y: 5}, {x: 12, y: 5}, {x: 13, y: 4}, {x: 15, y: 3}, {x: 10, y: 2}, {x: 9, y: 1}].reverse,
                                    inner: []}])
    end
    it "scans butterfly" do
      chunk = "0000000000000000" \
               "0000AAA000LL0000" \
               "000BBBB00IIII000" \
               "00CCCCCCCCCCCC00" \
               "00DDDDDDDDDDDD00" \
               "000EEEE00GGGG000" \
               "0000FF0000HH0000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDGHGDCILICBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 4, y: 1}, {x: 3, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 3, y: 5}, {x: 4, y: 6}, {x: 5, y: 6}, {x: 6, y: 5}, {x: 9, y: 5}, {x: 10, y: 6}, {x: 11, y: 6}, {x: 12, y: 5}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 12, y: 2}, {x: 11, y: 1}, {x: 10, y: 1}, {x: 9, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
                                    inner: []}])
    end
    it "scans butterfly 2" do
      chunk = "0000000000AA0000" \
               "0000FFF000BB0000" \
               "000EEEE00CCCC000" \
               "00DDDDDDDDDDDD00" \
               "00GGGGGGGGGGGG00" \
               "000HHHH00LLLL000" \
               "0000II0000MM0000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDGHIHGLMLGDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 10, y: 0}, {x: 10, y: 1}, {x: 9, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}, {x: 4, y: 1}, {x: 3, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 3, y: 5}, {x: 4, y: 6}, {x: 5, y: 6}, {x: 6, y: 5}, {x: 9, y: 5}, {x: 10, y: 6}, {x: 11, y: 6}, {x: 12, y: 5}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 12, y: 2}, {x: 11, y: 1}, {x: 11, y: 0}],
                                    inner: []}])
    end
    it "scans butterfly 2 visval compression" do
      chunk = "0000000000AA0000" \
               "0000FFF000BB0000" \
               "000EEEE00CCCC000" \
               "00DDDDDDDDDDDD00" \
               "00GGGGGGGGGGGG00" \
               "000HHHH00LLLL000" \
               "0000II0000MM0000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true, compress: {visvalingam: {tolerance: 1.5}}}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDGHIHGLMLGDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 10, y: 0}, {x: 9, y: 2}, {x: 4, y: 1}, {x: 2, y: 3}, {x: 4, y: 6}, {x: 9, y: 5}, {x: 11, y: 6}, {x: 13, y: 4}, {x: 11, y: 0}],
                                    inner: []}])
    end
    it "scans butterfly 3" do
      chunk = "0000000000000000" \
               "0000AAA000III000" \
               "000BBBB00HHHHH00" \
               "00CCCCCCCCCCCC00" \
               "000DDDD00FFFFF00" \
               "0000EE0000GG0000" \
               "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCFGFCHIHCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 4, y: 1}, {x: 3, y: 2}, {x: 2, y: 3}, {x: 3, y: 4}, {x: 4, y: 5}, {x: 5, y: 5}, {x: 6, y: 4}, {x: 9, y: 4}, {x: 10, y: 5}, {x: 11, y: 5}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 12, y: 1}, {x: 10, y: 1}, {x: 9, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
                                    inner: []}])
    end
    it "scans block 3" do
      chunk = "0000000000000000" \
              "AAA000EEE000GGG0" \
              "BBB000DDD000FFF0" \
              "CCCCCCCCCCCCCCC0" \
              "0000000000000000" \
              "0000000000000000" \
              "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCFGFCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 12, y: 1}, {x: 12, y: 2}, {x: 8, y: 2}, {x: 8, y: 1}, {x: 6, y: 1}, {x: 6, y: 2}, {x: 2, y: 2}, {x: 2, y: 1}],
                                    inner: []}])
    end
    it "scans block 3 inverted" do
      chunk = "0000000000000000" \
              "AAAAAAAAAAAAAAA0" \
              "BBB000DDD000FFF0" \
              "CCC000EEE000GGG0" \
              "0000000000000000" \
              "0000000000000000" \
              "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCBADEDAFGFA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 2, y: 3}, {x: 2, y: 2}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 8, y: 3}, {x: 8, y: 2}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}],
                                    inner: []}])
    end
    it "scans 3 holed polygon", thp: true do
      chunk = "0000000000000000" \
              "AAAAAAAAAAAAAAA0" \
              "BB00MM00NN000HH0" \
              "CC00LL00OO000GG0" \
              "DD00II00PP000FF0" \
              "EEEEEEEEEEEEEEE0" \
              "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHA")
      expect(result.metadata[:groups]).to eq(1)
      # puts result.points
      expect(result.points).to eq([
        {outer: [{x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 14, y: 5}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}],
         inner: [
           [{x: 1, y: 2}, {x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}, {x: 1, y: 4}, {x: 1, y: 3}],
           [{x: 13, y: 4}, {x: 9, y: 4}, {x: 9, y: 3}, {x: 9, y: 2}, {x: 13, y: 2}, {x: 13, y: 3}],
           [{x: 5, y: 2}, {x: 8, y: 2}, {x: 8, y: 3}, {x: 8, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}]

         ]}
      ])
    end
    it "scans 2 holed polygon" do
      chunk = "0AAAAAAAAAAAAAA0" \
              "0BB00HHHHHHHHHH0" \
              "0CC00IIIIIIIIII0" \
              "0DDDDDDDDDDDDDD0" \
              "0EE00LLLLLLLLLL0" \
              "0FF00MMMMMMMMMM0" \
              "0GGGGGGGGGGGGGG0"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGMLDIHA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 1, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 1, y: 5}, {x: 1, y: 6}, {x: 14, y: 6}, {x: 14, y: 5}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 14, y: 0}],
         inner: [
           [{x: 2, y: 1}, {x: 5, y: 1}, {x: 5, y: 2}, {x: 2, y: 2}],
           [{x: 2, y: 4}, {x: 5, y: 4}, {x: 5, y: 5}, {x: 2, y: 5}]
         ]}
      ])
    end

    it "scans 2 holed polygon complex", pocomp: true do
      chunk = "0000000000000000" \
              "AAAAAAAAAAAAAAA0" \
              "BB00MM0000000HH0" \
              "CC00LL00OO000GG0" \
              "DD00II00PP000FF0" \
              "EEEEEEEEEEEEEEE0" \
              "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 14, y: 5}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}],
         inner: [
           [{x: 1, y: 2}, {x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}, {x: 1, y: 4}, {x: 1, y: 3}],
           [{x: 13, y: 4}, {x: 9, y: 4}, {x: 9, y: 3}, {x: 8, y: 3}, {x: 8, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 5, y: 2}, {x: 13, y: 2}, {x: 13, y: 3}]
         ]}
      ])
    end

    it "loses some mia", mia: true do
      chunk = "AAAAAAAAAAAAAAAA" \
              "BBBBBBBBBBBBBB0C" \
              "DDDDD0000000EE0F" \
              "I0000000000000GG" \
              "HHHHHHHHHHHHHHHH" \
              "0000000000000000" \
              "0000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABDIHGFCA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 15, y: 4}, {x: 15, y: 3}, {x: 15, y: 2}, {x: 15, y: 1}, {x: 15, y: 0}],
                                    inner: [[{x: 4, y: 2}, {x: 12, y: 2}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 15, y: 1}, {x: 15, y: 2}, {x: 14, y: 3}, {x: 0, y: 3}]]}])
    end

    it "scans 2 holed polygon outer full" do
      chunk = "AAAAAAAAAAAAAAAA" \
               "BBBBB00NNNNNNNNN" \
               "CCCC000000MMMMMM" \
               "DDD00000000LLLLL" \
               "EEEE000000IIIIII" \
               "FFFFFFF00HHHHHHH" \
               "GGGGGGGGGGGGGGGG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHILMNA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6}, {x: 15, y: 6}, {x: 15, y: 5}, {x: 15, y: 4}, {x: 15, y: 3}, {x: 15, y: 2}, {x: 15, y: 1}, {x: 15, y: 0}],
         inner: [[{x: 4, y: 1}, {x: 7, y: 1}, {x: 10, y: 2}, {x: 11, y: 3}, {x: 10, y: 4}, {x: 9, y: 5}, {x: 6, y: 5}, {x: 3, y: 4}, {x: 2, y: 3}, {x: 3, y: 2}]]}
      ])
    end
    it "scans 2 holed polygon outer full clockwise", hopi: true do
      chunk = "AAAAAAAAAAAAAAAA" \
               "BBBBB00NNNNNNNNN" \
               "CCCC000000MMMMMM" \
               "DDD00000000LLLLL" \
               "EEEE000000IIIIII" \
               "FFFFFFF00HHHHHHH" \
               "GGGGGGGGGGGGGGGG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ANMLIHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6}, {x: 15, y: 6}, {x: 15, y: 5}, {x: 15, y: 4}, {x: 15, y: 3}, {x: 15, y: 2}, {x: 15, y: 1}, {x: 15, y: 0}].reverse,
         inner: [[{x: 7, y: 1}, {x: 4, y: 1}, {x: 3, y: 2}, {x: 2, y: 3}, {x: 3, y: 4}, {x: 6, y: 5}, {x: 9, y: 5}, {x: 10, y: 4}, {x: 11, y: 3}, {x: 10, y: 2}]]}
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
      finder = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true})
      result = finder.process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGQPONMA-SRS")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to eq([{outer: [{x: 2, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 2, y: 5}, {x: 3, y: 6}, {x: 13, y: 6}, {x: 14, y: 5},
        {x: 14, y: 4}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 13, y: 0}],
                                    inner: [[{x: 2, y: 1}, {x: 5, y: 1}, {x: 5, y: 2}, {x: 2, y: 2}],
                                      [{x: 2, y: 4}, {x: 6, y: 4}, {x: 6, y: 5}, {x: 3, y: 5}],
                                      [{x: 13, y: 5}, {x: 8, y: 5}, {x: 7, y: 4}, {x: 6, y: 3}, {x: 6, y: 2}, {x: 14, y: 2}, {x: 14, y: 3}, {x: 14, y: 4}]]},

        {outer: [{x: 10, y: 3}, {x: 10, y: 4}, {x: 11, y: 4}, {x: 11, y: 3}], inner: []}])
    end

    it "j form", j_form: true do
      chunk = "00000000AAAAAA00000000000000000" \
              "BBBBB00CCCCCCCC0000000000000000" \
              "0DDDDD00EE0FFFF0000000000000000" \
              "0GGGGG00HHHH0III000000000000000" \
              "0JJJJJJJJJJJJ0KKK00000000000000" \
              "0000LLLLLLLLLL0MM00000000000000" \
              "0000NNN0OOOOOOOOOO0000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 31), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ACEHJGDBDGJLNLOMKIFCA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 8, y: 0}, {x: 7, y: 1}, {x: 8, y: 2}, {x: 8, y: 3}, {x: 5, y: 3}, {x: 5, y: 2}, {x: 4, y: 1}, {x: 0, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 4, y: 5}, {x: 4, y: 6}, {x: 6, y: 6}, {x: 8, y: 6}, {x: 17, y: 6}, {x: 16, y: 5}, {x: 16, y: 4}, {x: 15, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 13, y: 0}], inner: [[{x: 9, y: 2}, {x: 11, y: 2}], [{x: 15, y: 5}, {x: 13, y: 5}, {x: 12, y: 4}, {x: 11, y: 3}, {x: 13, y: 3}, {x: 14, y: 4}]]}])
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
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {treemap: true, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFNPQGHLMLIGQPNFEDLMA-RSR")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 1]])
      expect(result.points).to eq([{outer: [{x: 2, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 1, y: 5}, {x: 1, y: 6}, {x: 1, y: 7}, {x: 1, y: 8}, {x: 1, y: 9}, {x: 1, y: 10}, {x: 2, y: 11}, {x: 3, y: 12}, {x: 14, y: 12}, {x: 14, y: 11}, {x: 14, y: 10}, {x: 14, y: 9}, {x: 14, y: 8}, {x: 14, y: 7}, {x: 14, y: 6}, {x: 14, y: 5}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 13, y: 0}], inner: [[{x: 2, y: 1}, {x: 5, y: 1}, {x: 5, y: 2}, {x: 2, y: 2}], [{x: 7, y: 5}, {x: 14, y: 5}, {x: 14, y: 6}, {x: 14, y: 7}, {x: 14, y: 8}, {x: 8, y: 8}, {x: 8, y: 7}, {x: 8, y: 6}], [{x: 2, y: 10}, {x: 6, y: 10}, {x: 6, y: 11}, {x: 3, y: 11}]]}, {outer: [{x: 11, y: 6}, {x: 11, y: 7}, {x: 12, y: 7}, {x: 12, y: 6}], inner: []}])
    end

    it "was a failing case" do
      chunk = "0010000000101000000" \
                "0001000010000000000" \
                "0001011011110100010" \
                "1111100111111110010" \
                "0111110011011110100" \
                "0111110011110111001" \
                "0111111111111011100" \
                "0010111111111101100" \
                "10001110CCCCCCCCCC0" \
                "11000AAAA00BBBB0111" \
                "111110DDDDDD0011111" \
                "1110000011111110111" \
                "1111001111111101111" \
                "1111011111000111111" \
                "1111011100111111111" \
                "0011111111111100000" \
                "1111110111110000010" \
                "1111111111111111111"
      dest = @bitmap_class.new(chunk, 19)
      dest.clear(" ")
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 19), @matcher, dest, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("1-1-1-1111111111AD1111111111111111111111111111111C1111111111111111111-1-111-1-1")
      expect(result.metadata[:groups]).to eq(8)
      expect(result.points).to eq(
        [{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 0, y: 3}, {x: 1, y: 4}, {x: 1, y: 5}, {x: 1, y: 6}, {x: 2, y: 7}, {x: 2, y: 7}, {x: 4, y: 7},
          {x: 4, y: 8}, {x: 5, y: 9}, {x: 6, y: 10}, {x: 8, y: 11}, {x: 6, y: 12}, {x: 5, y: 13}, {x: 5, y: 14}, {x: 3, y: 14},
          {x: 3, y: 13}, {x: 3, y: 12}, {x: 2, y: 11}, {x: 4, y: 10}, {x: 1, y: 9}, {x: 0, y: 8}, {x: 0, y: 8}, {x: 0, y: 9},
          {x: 0, y: 10}, {x: 0, y: 11}, {x: 0, y: 12}, {x: 0, y: 13}, {x: 0, y: 14}, {x: 2, y: 15}, {x: 0, y: 16}, {x: 0, y: 17},
          {x: 18, y: 17}, {x: 17, y: 16}, {x: 17, y: 16}, {x: 11, y: 16}, {x: 13, y: 15}, {x: 18, y: 14}, {x: 18, y: 13}, {x: 18, y: 12},
          {x: 18, y: 11}, {x: 18, y: 10}, {x: 18, y: 9}, {x: 17, y: 8}, {x: 16, y: 7}, {x: 16, y: 6}, {x: 15, y: 5}, {x: 14, y: 4},
          {x: 14, y: 3}, {x: 13, y: 2}, {x: 13, y: 2}, {x: 11, y: 2}, {x: 8, y: 1}, {x: 8, y: 1}, {x: 8, y: 2}, {x: 7, y: 3},
          {x: 8, y: 4}, {x: 8, y: 5}, {x: 5, y: 5}, {x: 5, y: 4}, {x: 4, y: 3}, {x: 3, y: 2}, {x: 3, y: 1}],
          inner: [[{x: 6, y: 8}, {x: 8, y: 8}],
            [{x: 9, y: 13}, {x: 13, y: 13}, {x: 10, y: 14}, {x: 7, y: 14}],
            [{x: 5, y: 16}, {x: 7, y: 16}],
            [{x: 15, y: 12}, {x: 13, y: 12}, {x: 14, y: 11}, {x: 16, y: 11}],
            [{x: 16, y: 9}, {x: 14, y: 9}],
            [{x: 15, y: 7}, {x: 13, y: 7}, {x: 12, y: 6}, {x: 11, y: 5}, {x: 13, y: 5}, {x: 14, y: 6}],
            [{x: 9, y: 4}, {x: 11, y: 4}],
            [{x: 11, y: 10}, {x: 14, y: 10}],
            [{x: 8, y: 9}, {x: 11, y: 9}]]},
          {outer: [{x: 17, y: 2}, {x: 17, y: 3}, {x: 17, y: 3}, {x: 17, y: 2}], inner: []}]
      )
    end

    it "scans labirinth", labyrinth: true do
      filename = "labyrinth2.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(@png_not_matcher_color)
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a, named_sequences: true, compress: {uniq: true, linear: true}})
      result = polygonfinder.process_info
      saved_poly = YAML.load_file("./spec/files/coordinates/#{filename}.yml")
      expect(result.points).to eq(saved_poly)
    end

    it "scans sample 270x257", sample_270x257: true do
      filename = "sample_270x257.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(@png_not_matcher_color)
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a, named_sequences: true, compress: {uniq: true, linear: true}})
      result = polygonfinder.process_info
      saved_poly = YAML.load_file("./spec/files/coordinates/#{filename}.yml")
      # puts result.points
      expect(result.points).to eq(saved_poly)
    end

    it "scans sample 254x250", sample_254x250: true do
      filename = "sample_254x250.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(@png_not_matcher_color)
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      saved_poly = YAML.load_file("./spec/files/coordinates/#{filename}.yml")
      expect(result.points).to eq(saved_poly)
    end

    it "works like a charm", charm: true do
      chunk = "AAAAAAAAAAAAAAAAAAAAA" \
                "BB00000000000000000TT" \
                "CC03333333333333330SS" \
                "DD02200000000000440RR" \
                "EE011000WWWWW000550QQ" \
                "FF0ZZZZZZ000$000660PP" \
                "GG0YY000%%%%%000770OO" \
                "HH0XX00000000000880NN" \
                "II0VVVVV00000999990MM" \
                "JJ0000UU00000!!0000LL" \
                "KKKKKKKKKKKKKKKKKKKKK"
      dest = @bitmap_class.new(chunk, 21)
      dest.clear(" ")
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 21), @matcher, dest, {versus: :a, named_sequences: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHIJKLMNOPQRSTA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 10}, {x: 20, y: 10}, {x: 20, y: 0}],
                                    inner: [
                                      [{x: 1, y: 1}, {x: 19, y: 1}, {x: 19, y: 9}, {x: 14, y: 9}, {x: 17, y: 8}, {x: 17, y: 2}, {x: 3, y: 2}, {x: 3, y: 8}, {x: 6, y: 9}, {x: 1, y: 9}, {x: 1, y: 2}],
                                      [{x: 13, y: 9}, {x: 7, y: 9}, {x: 7, y: 8}, {x: 4, y: 7}, {x: 4, y: 6}, {x: 12, y: 6}, {x: 12, y: 4}, {x: 4, y: 4}, {x: 4, y: 3}, {x: 16, y: 3}, {x: 16, y: 7}, {x: 13, y: 8}],
                                      [{x: 12, y: 5}, {x: 8, y: 5}]
                                    ]}])
    end
    it "was a failing case 2", prob5: true do
      chunk = "0000AAAAAAAAAA00000" \
                "0000BBB0CCCCCCCCCC0" \
                "00000DDDD00EEEE0FFF" \
                "000000GGGGGG00HHHHH" \
                "00000000IIIIIII0LLL"
      dest = @bitmap_class.new(chunk, 19)
      dest.clear(" ")
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 19), @matcher, dest, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABDGIHLHFCA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 4, y: 0}, {x: 4, y: 1}, {x: 5, y: 2}, {x: 6, y: 3}, {x: 8, y: 4}, {x: 14, y: 4}, {x: 16, y: 4}, {x: 18, y: 4}, {x: 18, y: 3}, {x: 18, y: 2}, {x: 17, y: 1}, {x: 13, y: 0}],
                                    inner: [[{x: 6, y: 1}, {x: 8, y: 1}],
                                      [{x: 16, y: 2}, {x: 14, y: 2}],
                                      [{x: 11, y: 3}, {x: 14, y: 3}],
                                      [{x: 8, y: 2}, {x: 11, y: 2}]]}])
    end
    it "was a failing case 3", prob5o: true do
      chunk = "0000AAAAAAAAAA00000" \
                "0000BBB0CCCCCCCCCC0" \
                "00000DDDD00EEEE0FFF" \
                "000000GGGGGG00HHHHH" \
                "00000000IIIIIII0LLL"
      dest = @bitmap_class.new(chunk, 19)
      dest.clear(" ")
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 19), @matcher, dest, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ACFHLHIGDBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 13, y: 0}, {x: 17, y: 1}, {x: 18, y: 2}, {x: 18, y: 3}, {x: 18, y: 4}, {x: 16, y: 4}, {x: 14, y: 4}, {x: 8, y: 4}, {x: 6, y: 3}, {x: 5, y: 2}, {x: 4, y: 1}, {x: 4, y: 0}],
                                    inner: [
                                      [{x: 16, y: 2}, {x: 14, y: 2}],
                                      [{x: 6, y: 1}, {x: 8, y: 1}],
                                      [{x: 11, y: 3}, {x: 14, y: 3}],
                                      [{x: 8, y: 2}, {x: 11, y: 2}]
                                    ]}])
    end

    it "was a failing case 4", prob2: true do
      chunk = "00000000AAAAAA00000000000000000" \
               "BBBBB00CCCCCCCC0000000000000000" \
               "0DDDDD00EE0FFFF0000000000000000" \
               "0GGGGG00HHHH0III000000000000000" \
               "0JJJJJJJJJJJJ0KKK00000000000000" \
               "0000LLLLLLLLLL0MM00000000000000" \
               "0000NNN0OOOOOOOOOO0000000000000"
      dest = @bitmap_class.new(chunk, 31)
      dest.clear(" ")
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 31), @matcher, dest, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ACEHJGDBDGJLNLOMKIFCA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 8, y: 0}, {x: 7, y: 1}, {x: 8, y: 2}, {x: 8, y: 3}, {x: 5, y: 3}, {x: 5, y: 2}, {x: 4, y: 1},
        {x: 0, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 4, y: 5}, {x: 4, y: 6}, {x: 6, y: 6},
        {x: 8, y: 6}, {x: 17, y: 6}, {x: 16, y: 5}, {x: 16, y: 4}, {x: 15, y: 3}, {x: 14, y: 2}, {x: 14, y: 1},
        {x: 13, y: 0}],
                                    inner: [[{x: 9, y: 2}, {x: 11, y: 2}],
                                      [{x: 15, y: 5}, {x: 13, y: 5}, {x: 12, y: 4}, {x: 11, y: 3}, {x: 13, y: 3}, {x: 14, y: 4}]]}])
    end

    it "multiple sequence", prob3: true do
      chunk = "00000000000000000000000000000000000" \
            "000000000000000AAAAA00BBBB000000000" \
            "00000000000000CCCCCCC0DDDD000100000" \
            "000000000000EEEE00FFF00GGG00HHH0III" \
            "000000000000JJ0KKKKK010000011110111" \
            "00000000000LL00MMMMMMMM000111110111" \
            "0001110000NN00OOOOOOOOOO00111110001" \
            "000111100PPP0QQQQ001111100111110000" \
            "00011100111110000111111011011100111" \
            "00001101111101011111110111011000111" \
            "00000011111101011111100111111111111" \
            "00000111111111000001110111111111111" \
            "00001111111111110100111010111111111" \
            "00011011100001011111110111100000000" \
            "00011011101000000111110111000000001" \
            "00011011100011111111111110000000001" \
            "00011111111111111111111111111111111" \
            "00111111110000101100000000001111111" \
            "11111111111111111100000000111111111" \
            "00011111100111111111111111111001111" \
            "01001111110011111111111111000011101" \
            "10001111111111111111111110111111001" \
            "11101101111111111111111100111110101" \
            "11100011111111100111011101011111010" \
            "11100011111111110100111111110011100" \
            "10000011110111111000111110111111101" \
            "11100011110111111100111110111111001" \
            "11100011110011111110111111011101100" \
            "11101111110101111100100011111111111" \
            "11100011110000011100000000111101110" \
            "01000011100000011100000000000001000" \
            "00000111110001000000000000010000010" \
            "00001011100000000000000000001100100" \
            "00000001001001001000000000000001000" \
            "01000110001010100000000000000000000"

      dest = @bitmap_class.new(chunk, 35)
      dest.clear(" ")
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 35), @matcher, dest, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ACEJLNP11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111H1H111111111111111111111111OM1MKFCA-BDGDB-I11111I-1111111-1-1-1111111111111111111-1-1-111-1-1-1-1-1-1-1-111-1-1-1-1-1-1-1")
      expect(result.metadata[:groups]).to eq(25)
      expect(result.points).to eq([{outer: [{x: 15, y: 1}, {x: 14, y: 2}, {x: 12, y: 3}, {x: 12, y: 4}, {x: 11, y: 5}, {x: 10, y: 6}, {x: 9, y: 7}, {x: 8, y: 8}, {x: 7, y: 9}, {x: 6, y: 10}, {x: 5, y: 11}, {x: 4, y: 12}, {x: 3, y: 13}, {x: 3, y: 14}, {x: 3, y: 15}, {x: 3, y: 16}, {x: 2, y: 17}, {x: 0, y: 18}, {x: 3, y: 19}, {x: 4, y: 20}, {x: 4, y: 21}, {x: 4, y: 22}, {x: 5, y: 22}, {x: 7, y: 22}, {x: 6, y: 23}, {x: 6, y: 24}, {x: 6, y: 25}, {x: 6, y: 26}, {x: 6, y: 27}, {x: 4, y: 28}, {x: 6, y: 29}, {x: 6, y: 30}, {x: 5, y: 31}, {x: 6, y: 32}, {x: 7, y: 33}, {x: 7, y: 33}, {x: 8, y: 32}, {x: 9, y: 31}, {x: 8, y: 30}, {x: 9, y: 29}, {x: 9, y: 28}, {x: 9, y: 27}, {x: 9, y: 26}, {x: 9, y: 25}, {x: 11, y: 25}, {x: 11, y: 26}, {x: 12, y: 27}, {x: 13, y: 28}, {x: 15, y: 29}, {x: 15, y: 30}, {x: 17, y: 30}, {x: 17, y: 29}, {x: 17, y: 28}, {x: 18, y: 27}, {x: 17, y: 26}, {x: 16, y: 25}, {x: 15, y: 24}, {x: 14, y: 23}, {x: 17, y: 23}, {x: 17, y: 24}, {x: 17, y: 24}, {x: 19, y: 23}, {x: 21, y: 23}, {x: 20, y: 24}, {x: 20, y: 25}, {x: 20, y: 26}, {x: 20, y: 27}, {x: 20, y: 28}, {x: 20, y: 28}, {x: 24, y: 28}, {x: 26, y: 29}, {x: 29, y: 29}, {x: 31, y: 29}, {x: 31, y: 30}, {x: 31, y: 30}, {x: 33, y: 29}, {x: 34, y: 28}, {x: 32, y: 27}, {x: 31, y: 26}, {x: 32, y: 25}, {x: 32, y: 24}, {x: 31, y: 23}, {x: 30, y: 22}, {x: 31, y: 21}, {x: 32, y: 20}, {x: 34, y: 20}, {x: 34, y: 21}, {x: 34, y: 22}, {x: 34, y: 22}, {x: 34, y: 21}, {x: 34, y: 20}, {x: 34, y: 19}, {x: 34, y: 18}, {x: 34, y: 17}, {x: 34, y: 16}, {x: 34, y: 15}, {x: 34, y: 14}, {x: 34, y: 14}, {x: 34, y: 15}, {x: 24, y: 15}, {x: 25, y: 14}, {x: 26, y: 13}, {x: 34, y: 12}, {x: 34, y: 11}, {x: 34, y: 10}, {x: 34, y: 9}, {x: 34, y: 8}, {x: 32, y: 8}, {x: 32, y: 9}, {x: 28, y: 9}, {x: 29, y: 8}, {x: 30, y: 7}, {x: 30, y: 6}, {x: 30, y: 5}, {x: 30, y: 4}, {x: 30, y: 3}, {x: 29, y: 2}, {x: 29, y: 2}, {x: 28, y: 3}, {x: 27, y: 4}, {x: 26, y: 5}, {x: 26, y: 6}, {x: 26, y: 7}, {x: 27, y: 8}, {x: 27, y: 9}, {x: 25, y: 9}, {x: 25, y: 8}, {x: 24, y: 8}, {x: 23, y: 9}, {x: 23, y: 10}, {x: 23, y: 11}, {x: 24, y: 12}, {x: 23, y: 13}, {x: 23, y: 14}, {x: 21, y: 14}, {x: 21, y: 13}, {x: 22, y: 12}, {x: 21, y: 11}, {x: 20, y: 10}, {x: 21, y: 9}, {x: 22, y: 8}, {x: 23, y: 7}, {x: 23, y: 6}, {x: 22, y: 5}, {x: 21, y: 4}, {x: 21, y: 4}, {x: 19, y: 4}, {x: 20, y: 3}, {x: 20, y: 2}, {x: 19, y: 1}], inner: [[{x: 13, y: 4}, {x: 15, y: 4}, {x: 15, y: 5}, {x: 14, y: 6}, {x: 13, y: 7}, {x: 16, y: 7}, {x: 19, y: 7}, {x: 17, y: 8}, {x: 15, y: 9}, {x: 15, y: 10}, {x: 19, y: 11}, {x: 20, y: 12}, {x: 17, y: 12}, {x: 17, y: 12}, {x: 15, y: 12}, {x: 13, y: 11}, {x: 13, y: 10}, {x: 13, y: 9}, {x: 13, y: 9}, {x: 13, y: 10}, {x: 11, y: 10}, {x: 11, y: 9}, {x: 12, y: 8}, {x: 11, y: 7}, {x: 11, y: 6}, {x: 12, y: 5}], [{x: 4, y: 13}, {x: 6, y: 13}, {x: 6, y: 14}, {x: 6, y: 15}, {x: 4, y: 15}, {x: 4, y: 14}], [{x: 9, y: 17}, {x: 14, y: 17}], [{x: 8, y: 19}, {x: 11, y: 19}, {x: 12, y: 20}, {x: 9, y: 20}], [{x: 23, y: 23}, {x: 23, y: 22}, {x: 24, y: 21}, {x: 25, y: 20}, {x: 28, y: 19}, {x: 31, y: 19}, {x: 30, y: 20}, {x: 26, y: 21}, {x: 26, y: 22}, {x: 27, y: 23}, {x: 25, y: 23}, {x: 25, y: 23}], [{x: 24, y: 25}, {x: 26, y: 25}, {x: 26, y: 26}, {x: 27, y: 27}, {x: 25, y: 27}, {x: 24, y: 26}], [{x: 31, y: 27}, {x: 29, y: 27}], [{x: 30, y: 24}, {x: 27, y: 24}], [{x: 28, y: 17}, {x: 26, y: 18}, {x: 17, y: 18}, {x: 17, y: 17}], [{x: 26, y: 12}, {x: 24, y: 12}], [{x: 17, y: 14}, {x: 12, y: 15}, {x: 8, y: 15}, {x: 8, y: 14}, {x: 8, y: 13}, {x: 13, y: 13}, {x: 13, y: 13}, {x: 15, y: 13}], [{x: 18, y: 3}, {x: 15, y: 3}], [{x: 14, y: 17}, {x: 16, y: 17}]]}, {outer: [{x: 22, y: 1}, {x: 22, y: 2}, {x: 23, y: 3}, {x: 25, y: 3}, {x: 25, y: 2}, {x: 25, y: 1}], inner: []}, {outer: [{x: 32, y: 3}, {x: 32, y: 4}, {x: 32, y: 5}, {x: 34, y: 6}, {x: 34, y: 6}, {x: 34, y: 5}, {x: 34, y: 4}, {x: 34, y: 3}], inner: []}, {outer: [{x: 3, y: 6}, {x: 3, y: 7}, {x: 3, y: 8}, {x: 4, y: 9}, {x: 5, y: 9}, {x: 5, y: 8}, {x: 6, y: 7}, {x: 5, y: 6}], inner: []}, {outer: [{x: 0, y: 21}, {x: 0, y: 22}, {x: 0, y: 23}, {x: 0, y: 24}, {x: 0, y: 25}, {x: 0, y: 26}, {x: 0, y: 27}, {x: 0, y: 28}, {x: 0, y: 29}, {x: 1, y: 30}, {x: 1, y: 30}, {x: 2, y: 29}, {x: 2, y: 28}, {x: 2, y: 27}, {x: 2, y: 26}, {x: 0, y: 25}, {x: 2, y: 24}, {x: 2, y: 23}, {x: 2, y: 22}, {x: 0, y: 21}], inner: []}, {outer: [{x: 34, y: 25}, {x: 34, y: 26}, {x: 34, y: 26}, {x: 34, y: 25}], inner: []}, {outer: [{x: 10, y: 33}, {x: 10, y: 34}, {x: 10, y: 34}, {x: 10, y: 33}], inner: []}])
    end
  end
end
