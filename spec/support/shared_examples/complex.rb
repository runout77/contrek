require "yaml"
RSpec.shared_examples "complex" do
  describe "simple cases" do
    it "faster indexing", faster_indexing: true do
      chunk = "                                                                                                                                                                                                        " \
               "A B C D E F G H I J K L M N O P Q R S T U V W X Y A B C D E F G H I J K L M N O P Q R S T U V W X Y A B C D E F G H I J K L M N O P Q R S T U V W X Y A B C D E F G H I J K L M N O P Q R S T U V W X Y " \
               "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" \
               "                                                                                                                                                                                                        "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 200), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZAZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZAZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZAZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 1}, {x: 0, y: 2}, {x: 199, y: 2}, {x: 198, y: 1}, {x: 198, y: 1}, {x: 196, y: 1}, {x: 196, y: 1}, {x: 194, y: 1}, {x: 194, y: 1}, {x: 192, y: 1}, {x: 192, y: 1}, {x: 190, y: 1}, {x: 190, y: 1}, {x: 188, y: 1}, {x: 188, y: 1}, {x: 186, y: 1}, {x: 186, y: 1}, {x: 184, y: 1}, {x: 184, y: 1}, {x: 182, y: 1}, {x: 182, y: 1}, {x: 180, y: 1}, {x: 180, y: 1}, {x: 178, y: 1}, {x: 178, y: 1}, {x: 176, y: 1}, {x: 176, y: 1}, {x: 174, y: 1}, {x: 174, y: 1}, {x: 172, y: 1}, {x: 172, y: 1}, {x: 170, y: 1}, {x: 170, y: 1}, {x: 168, y: 1}, {x: 168, y: 1}, {x: 166, y: 1}, {x: 166, y: 1}, {x: 164, y: 1}, {x: 164, y: 1}, {x: 162, y: 1}, {x: 162, y: 1}, {x: 160, y: 1}, {x: 160, y: 1}, {x: 158, y: 1}, {x: 158, y: 1}, {x: 156, y: 1}, {x: 156, y: 1}, {x: 154, y: 1}, {x: 154, y: 1}, {x: 152, y: 1}, {x: 152, y: 1}, {x: 150, y: 1}, {x: 150, y: 1}, {x: 148, y: 1}, {x: 148, y: 1}, {x: 146, y: 1}, {x: 146, y: 1}, {x: 144, y: 1}, {x: 144, y: 1}, {x: 142, y: 1}, {x: 142, y: 1}, {x: 140, y: 1}, {x: 140, y: 1}, {x: 138, y: 1}, {x: 138, y: 1}, {x: 136, y: 1}, {x: 136, y: 1}, {x: 134, y: 1}, {x: 134, y: 1}, {x: 132, y: 1}, {x: 132, y: 1}, {x: 130, y: 1}, {x: 130, y: 1}, {x: 128, y: 1}, {x: 128, y: 1}, {x: 126, y: 1}, {x: 126, y: 1}, {x: 124, y: 1}, {x: 124, y: 1}, {x: 122, y: 1}, {x: 122, y: 1}, {x: 120, y: 1}, {x: 120, y: 1}, {x: 118, y: 1}, {x: 118, y: 1}, {x: 116, y: 1}, {x: 116, y: 1}, {x: 114, y: 1}, {x: 114, y: 1}, {x: 112, y: 1}, {x: 112, y: 1}, {x: 110, y: 1}, {x: 110, y: 1}, {x: 108, y: 1}, {x: 108, y: 1}, {x: 106, y: 1}, {x: 106, y: 1}, {x: 104, y: 1}, {x: 104, y: 1}, {x: 102, y: 1}, {x: 102, y: 1}, {x: 100, y: 1}, {x: 100, y: 1}, {x: 98, y: 1}, {x: 98, y: 1}, {x: 96, y: 1}, {x: 96, y: 1}, {x: 94, y: 1}, {x: 94, y: 1}, {x: 92, y: 1}, {x: 92, y: 1}, {x: 90, y: 1}, {x: 90, y: 1}, {x: 88, y: 1}, {x: 88, y: 1}, {x: 86, y: 1}, {x: 86, y: 1}, {x: 84, y: 1}, {x: 84, y: 1}, {x: 82, y: 1}, {x: 82, y: 1}, {x: 80, y: 1}, {x: 80, y: 1}, {x: 78, y: 1}, {x: 78, y: 1}, {x: 76, y: 1}, {x: 76, y: 1}, {x: 74, y: 1}, {x: 74, y: 1}, {x: 72, y: 1}, {x: 72, y: 1}, {x: 70, y: 1}, {x: 70, y: 1}, {x: 68, y: 1}, {x: 68, y: 1}, {x: 66, y: 1}, {x: 66, y: 1}, {x: 64, y: 1}, {x: 64, y: 1}, {x: 62, y: 1}, {x: 62, y: 1}, {x: 60, y: 1}, {x: 60, y: 1}, {x: 58, y: 1}, {x: 58, y: 1}, {x: 56, y: 1}, {x: 56, y: 1}, {x: 54, y: 1}, {x: 54, y: 1}, {x: 52, y: 1}, {x: 52, y: 1}, {x: 50, y: 1}, {x: 50, y: 1}, {x: 48, y: 1}, {x: 48, y: 1}, {x: 46, y: 1}, {x: 46, y: 1}, {x: 44, y: 1}, {x: 44, y: 1}, {x: 42, y: 1}, {x: 42, y: 1}, {x: 40, y: 1}, {x: 40, y: 1}, {x: 38, y: 1}, {x: 38, y: 1}, {x: 36, y: 1}, {x: 36, y: 1}, {x: 34, y: 1}, {x: 34, y: 1}, {x: 32, y: 1}, {x: 32, y: 1}, {x: 30, y: 1}, {x: 30, y: 1}, {x: 28, y: 1}, {x: 28, y: 1}, {x: 26, y: 1}, {x: 26, y: 1}, {x: 24, y: 1}, {x: 24, y: 1}, {x: 22, y: 1}, {x: 22, y: 1}, {x: 20, y: 1}, {x: 20, y: 1}, {x: 18, y: 1}, {x: 18, y: 1}, {x: 16, y: 1}, {x: 16, y: 1}, {x: 14, y: 1}, {x: 14, y: 1}, {x: 12, y: 1}, {x: 12, y: 1}, {x: 10, y: 1}, {x: 10, y: 1}, {x: 8, y: 1}, {x: 8, y: 1}, {x: 6, y: 1}, {x: 6, y: 1}, {x: 4, y: 1}, {x: 4, y: 1}, {x: 2, y: 1}, {x: 2, y: 1}, {x: 0, y: 1}], inner: []}])
    end
    it "scan complex tree", complex_tree: true do
      chunk = "                " \
               "    AAAAAAAA    " \
               "   BBB    II    " \
               "  CC  HH LLL    " \
               " DDDD GG        " \
               "  EEEEEE        " \
               "   FF           "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEGHGEDCBAILIA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 4, y: 1}, {x: 3, y: 2}, {x: 2, y: 3}, {x: 1, y: 4}, {x: 2, y: 5}, {x: 3, y: 6}, {x: 4, y: 6}, {x: 7, y: 5}, {x: 7, y: 4}, {x: 7, y: 3}, {x: 6, y: 3}, {x: 6, y: 4}, {x: 4, y: 4}, {x: 3, y: 3}, {x: 5, y: 2}, {x: 10, y: 2}, {x: 9, y: 3}, {x: 11, y: 3}, {x: 11, y: 2}, {x: 11, y: 1}],
         inner: []}
      ])
    end
    it "scan U polygon" do
      chunk = "                " \
                  "   AAAA   EEEE  " \
                  "   BBBB   DDDD  " \
                  "   CCCCCCCCCCC  " \
                  "                " \
                  "                " \
                  "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
         inner: []}
      ])
    end
    it "scan U polygon clockwise" do
      chunk = "                " \
                  "   AAAA   EEEE  " \
                  "   BBBB   DDDD  " \
                  "   CCCCCCCCCCC  " \
                  "                " \
                  "                " \
                  "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}].reverse,
         inner: []}
      ])
    end
    it "scan U polygon wider baseline" do
      chunk = "                " \
                 "   AAAA   FFFF  " \
                 "   BBBB   EEEE  " \
                 "   CCCCCCCCCCC  " \
                 "   DDDDDDDDDDD  " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCEFECBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
         inner: []}
      ])
    end
    it "scan N polygon" do
      chunk = "                " \
               "   AAAAAAAAAAA  " \
               "   BBBB   DDDD  " \
               "   CCCC   EEEE  " \
               "                " \
               "                " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCBADEDA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 6, y: 3}, {x: 6, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}],
                                    inner: []}])
    end
    it "scan N polygon clockwise" do
      chunk = "                " \
               "   AAAAAAAAAAA  " \
               "   BBBB   DDDD  " \
               "   CCCC   EEEE  " \
               "                " \
               "                " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ADEDABCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 6, y: 3}, {x: 6, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}].reverse,
                                    inner: []}])
    end
    it "scans holed polygon" do
      chunk = "                " \
                 "      AAA       " \
                 "     BB DDD     " \
                 "      CCC       " \
                 "                " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 6, y: 1}, {x: 5, y: 2}, {x: 6, y: 3}, {x: 8, y: 3}, {x: 10, y: 2}, {x: 8, y: 1}], inner: [[{x: 6, y: 2}, {x: 8, y: 2}]]}])
    end
    it "scans holed polygon 2" do
      chunk = "                " \
                 "   AAAAAAAAAAA  " \
                 "   BBBB   HHHH  " \
                 "   CCC     GG   " \
                 "  DDDD  FFFFF   " \
                 "    EEEEEEEE    " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 2, y: 4}, {x: 4, y: 5}, {x: 11, y: 5}, {x: 12, y: 4}, {x: 12, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}],
                                    inner: [[{x: 6, y: 2}, {x: 10, y: 2}, {x: 11, y: 3}, {x: 8, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}]]}])
    end
    it "scan sequence" do
      chunk = "                " \
                 "                " \
                 "                " \
                 "  AAAAAA     E  " \
                 "    BBBBB    DD " \
                 "       CCCCCCC  " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 2, y: 3}, {x: 4, y: 4}, {x: 7, y: 5}, {x: 13, y: 5}, {x: 14, y: 4}, {x: 13, y: 3}, {x: 13, y: 3}, {x: 13, y: 4}, {x: 8, y: 4}, {x: 7, y: 3}],
         inner: []}
      ])
    end
    it "scan an opened polygon" do
      chunk = "                " \
                 "                " \
                 "                " \
                 "  AAAAAA     F  " \
                 "    BBBBB    EE " \
                 "       CCCCCCC  " \
                 "        DDDDD   "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCEFECBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 2, y: 3}, {x: 4, y: 4}, {x: 7, y: 5}, {x: 8, y: 6}, {x: 12, y: 6}, {x: 13, y: 5}, {x: 14, y: 4}, {x: 13, y: 3}, {x: 13, y: 3}, {x: 13, y: 4}, {x: 8, y: 4}, {x: 7, y: 3}],
                                    inner: []}])
    end
    it "scans M polygon" do
      chunk = "                " \
                "   AAAAAAAAAAAA " \
                "   B  C     D   " \
                "                " \
                "                " \
                "                " \
                "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABACADA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([
        {outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 3, y: 2}, {x: 6, y: 2}, {x: 6, y: 2}, {x: 12, y: 2}, {x: 12, y: 2}, {x: 14, y: 1}],
         inner: []}
      ])
    end
    it "scans W poligon" do
      chunk = "                " \
                "   A   C    D   " \
                "   BBBBBBBBBB   " \
                "                " \
                "                " \
                "                " \
                "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABDBCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 12, y: 2}, {x: 12, y: 1}, {x: 12, y: 1}, {x: 7, y: 1}, {x: 7, y: 1}, {x: 3, y: 1}],
                                    inner: []}])
    end
    it "scan W inverted polygon" do
      chunk = "                " \
                "                " \
                "   B  C     D   " \
                "   AAAAAAAAAAAA " \
                "              E " \
                "                " \
                "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("BAEADACAB")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 3, y: 2}, {x: 3, y: 3}, {x: 14, y: 4}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 12, y: 2}, {x: 12, y: 2}, {x: 6, y: 2}, {x: 6, y: 2}, {x: 3, y: 2}],
                                    inner: []}])
    end
    it "scans N polygon" do
      chunk = "                " \
                 "            AA  " \
                 "    FFFFFF  BB  " \
                 "    GG  EE  CC  " \
                 "    HH  DDDDDD  " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 12, y: 1}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 9, y: 3}, {x: 9, y: 2}, {x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 8, y: 3}, {x: 8, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}],
                                    inner: []}])
    end
    it "scans N polygon clockwise" do
      chunk = "                " \
                 "            AA  " \
                 "    FFFFFF  BB  " \
                 "    GG  EE  CC  " \
                 "    HH  DDDDDD  " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 12, y: 1}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 9, y: 3}, {x: 9, y: 2}, {x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 8, y: 3}, {x: 8, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}].reverse,
                                    inner: []}])
    end
    it "scans N polygon other root node" do
      chunk = "                " \
               "                " \
               "    AAAAAA  GG  " \
               "    BB  DD  FF  " \
               "    CC  EEEEEE  " \
               "                " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCBADEFGFEDA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 8, y: 3}, {x: 8, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 9, y: 3}, {x: 9, y: 2}],
                                    inner: []}])
    end
    it "scan snake" do
      chunk = "                " \
               "             A  " \
               "   P LLL FFF B  " \
               "   O M I G E C  " \
               "   NNN HHH DDD  " \
               "                " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHILMNOPONMLIHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 13, y: 1}, {x: 13, y: 2}, {x: 13, y: 3}, {x: 11, y: 3}, {x: 11, y: 2}, {x: 9, y: 2}, {x: 9, y: 3}, {x: 7, y: 3}, {x: 7, y: 2}, {x: 5, y: 2}, {x: 5, y: 3}, {x: 3, y: 3}, {x: 3, y: 2}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 7, y: 3}, {x: 7, y: 4}, {x: 9, y: 4}, {x: 9, y: 3}, {x: 11, y: 3}, {x: 11, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}],
                                    inner: []}])
    end
    it "scan complex" do
      chunk = "               A" \
              "NNNNNNNNNNNNNN B" \
              "M            O C" \
              "L R          P D" \
              "I QQQQQQQQQQQQ E" \
              "H              F" \
              "GGGGGGGGGGGGGGGG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGHILMNOPQRQPONMLIHGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 15, y: 0}, {x: 15, y: 1}, {x: 15, y: 2}, {x: 15, y: 3}, {x: 15, y: 4}, {x: 15, y: 5}, {x: 0, y: 5}, {x: 0, y: 4}, {x: 0, y: 3}, {x: 0, y: 2}, {x: 13, y: 2}, {x: 13, y: 3}, {x: 2, y: 3}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 0, y: 5}, {x: 0, y: 6}, {x: 15, y: 6}, {x: 15, y: 5}, {x: 15, y: 4}, {x: 15, y: 3}, {x: 15, y: 2}, {x: 15, y: 1}, {x: 15, y: 0}],
                                    inner: []}])
    end
    it "scan open sequence" do
      chunk = "AAAAAAAAA       " \
               "        BBB     " \
               "          CCCC  " \
               "   FFFF   DDDD  " \
               "   EEEEEEEEEEE  " \
               "                " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 8, y: 1}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 6, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 10, y: 1}, {x: 8, y: 0}],
                                    inner: []}])
    end
    it "scan open sequence clockwise" do
      chunk = "AAAAAAAAA       " \
               "        BBB     " \
               "          CCCC  " \
               "   FFFF   DDDD  " \
               "   EEEEEEEEEEE  " \
               "                " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 8, y: 1}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 6, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 10, y: 1}, {x: 8, y: 0}].reverse,
                                    inner: []}])
    end
    it "scan inverse two times" do
      chunk = "                " \
               "                " \
               "          AAAA  " \
               "   DDDD   BBBB  " \
               "   CCCCCCCCCCC  " \
               "                " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 10, y: 2}, {x: 10, y: 3}, {x: 6, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}],
                                    inner: []}])
    end
    it "case A" do
      chunk = "AA              " \
                 " BB             " \
                 "  CC            " \
                 "   DDDDDDDDDD   " \
                 "            EE  " \
                 "             FF " \
                 "              GG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 1, y: 1}, {x: 2, y: 2}, {x: 3, y: 3}, {x: 12, y: 4}, {x: 13, y: 5}, {x: 14, y: 6}, {x: 15, y: 6}, {x: 14, y: 5}, {x: 13, y: 4}, {x: 12, y: 3}, {x: 3, y: 2}, {x: 2, y: 1}, {x: 1, y: 0}],
                                    inner: []}])
    end
    it "case B arrow" do
      chunk = "              AA" \
                 "             BB " \
                 "            CC  " \
                 "DDDDDDDDDDDDD   " \
                 "            EE  " \
                 "             FF " \
                 "              GG"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGFEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 14, y: 0}, {x: 13, y: 1}, {x: 12, y: 2}, {x: 0, y: 3}, {x: 12, y: 4}, {x: 13, y: 5}, {x: 14, y: 6}, {x: 15, y: 6}, {x: 14, y: 5}, {x: 13, y: 4}, {x: 12, y: 3}, {x: 13, y: 2}, {x: 14, y: 1}, {x: 15, y: 0}],
                                    inner: []}])
    end
    it "scans V inverted" do
      chunk = "                " \
                 "       AAA      " \
                 "     BBBBBB     " \
                 "   CCCC  FFFFFFF" \
                 "  DDDD     GGG  " \
                 "   EE       H   " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCBFGHGFBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 7, y: 1}, {x: 5, y: 2}, {x: 3, y: 3}, {x: 2, y: 4}, {x: 3, y: 5}, {x: 4, y: 5}, {x: 5, y: 4}, {x: 6, y: 3}, {x: 9, y: 3}, {x: 11, y: 4}, {x: 12, y: 5}, {x: 12, y: 5}, {x: 13, y: 4}, {x: 15, y: 3}, {x: 10, y: 2}, {x: 9, y: 1}],
                                    inner: []}])
    end
    it "scans V inverted clockwise" do
      chunk = "                " \
                 "       AAA      " \
                 "     BBBBBB     " \
                 "   CCCC  FFFFFFF" \
                 "  DDDD     GGG  " \
                 "   EE       H   " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :o, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABFGHGFBCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 7, y: 1}, {x: 5, y: 2}, {x: 3, y: 3}, {x: 2, y: 4}, {x: 3, y: 5}, {x: 4, y: 5}, {x: 5, y: 4}, {x: 6, y: 3}, {x: 9, y: 3}, {x: 11, y: 4}, {x: 12, y: 5}, {x: 12, y: 5}, {x: 13, y: 4}, {x: 15, y: 3}, {x: 10, y: 2}, {x: 9, y: 1}].reverse,
                                    inner: []}])
    end
    it "scans butterfly" do
      chunk = "                " \
               "    AAA   LL    " \
               "   BBBB  IIII   " \
               "  CCCCCCCCCCCC  " \
               "  DDDDDDDDDDDD  " \
               "   EEEE  GGGG   " \
               "    FF    HH    " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDGHGDCILICBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 4, y: 1}, {x: 3, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 3, y: 5}, {x: 4, y: 6}, {x: 5, y: 6}, {x: 6, y: 5}, {x: 9, y: 5}, {x: 10, y: 6}, {x: 11, y: 6}, {x: 12, y: 5}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 12, y: 2}, {x: 11, y: 1}, {x: 10, y: 1}, {x: 9, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
                                    inner: []}])
    end
    it "scans butterfly 2" do
      chunk = "          AA    " \
               "    FFF   BB    " \
               "   EEEE  CCCC   " \
               "  DDDDDDDDDDDD  " \
               "  GGGGGGGGGGGG  " \
               "   HHHH  LLLL   " \
               "    II    MM    " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDGHIHGLMLGDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 10, y: 0}, {x: 10, y: 1}, {x: 9, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}, {x: 4, y: 1}, {x: 3, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 3, y: 5}, {x: 4, y: 6}, {x: 5, y: 6}, {x: 6, y: 5}, {x: 9, y: 5}, {x: 10, y: 6}, {x: 11, y: 6}, {x: 12, y: 5}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 12, y: 2}, {x: 11, y: 1}, {x: 11, y: 0}],
                                    inner: []}])
    end
    it "scans butterfly 2 visval compression" do
      chunk = "          AA    " \
               "    FFF   BB    " \
               "   EEEE  CCCC   " \
               "  DDDDDDDDDDDD  " \
               "  GGGGGGGGGGGG  " \
               "   HHHH  LLLL   " \
               "    II    MM    " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true, compress: {visvalingam: {tolerance: 1.5}}}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFEDGHIHGLMLGDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 10, y: 0}, {x: 9, y: 2}, {x: 4, y: 1}, {x: 2, y: 3}, {x: 4, y: 6}, {x: 9, y: 5}, {x: 11, y: 6}, {x: 13, y: 4}, {x: 11, y: 0}],
                                    inner: []}])
    end
    it "scans butterfly 3" do
      chunk = "                " \
               "    AAA   III   " \
               "   BBBB  HHHHH  " \
               "  CCCCCCCCCCCC  " \
               "   DDDD  FFFFF  " \
               "    EE    GG    " \
               "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEDCFGFCHIHCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 4, y: 1}, {x: 3, y: 2}, {x: 2, y: 3}, {x: 3, y: 4}, {x: 4, y: 5}, {x: 5, y: 5}, {x: 6, y: 4}, {x: 9, y: 4}, {x: 10, y: 5}, {x: 11, y: 5}, {x: 13, y: 4}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 12, y: 1}, {x: 10, y: 1}, {x: 9, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}],
                                    inner: []}])
    end
    it "scans block 3" do
      chunk = "                " \
              "AAA   EEE   GGG " \
              "BBB   DDD   FFF " \
              "CCCCCCCCCCCCCCC " \
              "                " \
              "                " \
              "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCFGFCDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 12, y: 1}, {x: 12, y: 2}, {x: 8, y: 2}, {x: 8, y: 1}, {x: 6, y: 1}, {x: 6, y: 2}, {x: 2, y: 2}, {x: 2, y: 1}],
                                    inner: []}])
    end
    it "scans block 3 inverted" do
      chunk = "                " \
              "AAAAAAAAAAAAAAA " \
              "BBB   DDD   FFF " \
              "CCC   EEE   GGG " \
              "                " \
              "                " \
              "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCBADEDAFGFA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 2, y: 3}, {x: 2, y: 2}, {x: 6, y: 2}, {x: 6, y: 3}, {x: 8, y: 3}, {x: 8, y: 2}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}],
                                    inner: []}])
    end
    it "scans 3 holed polygon", thp: true do
      chunk = "                " \
              "AAAAAAAAAAAAAAA " \
              "BB  MM  NN   HH " \
              "CC  LL  OO   GG " \
              "DD  II  PP   FF " \
              "EEEEEEEEEEEEEEE " \
              "                "
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
      chunk = " AAAAAAAAAAAAAA " \
              " BB  HHHHHHHHHH " \
              " CC  IIIIIIIIII " \
              " DDDDDDDDDDDDDD " \
              " EE  LLLLLLLLLL " \
              " FF  MMMMMMMMMM " \
              " GGGGGGGGGGGGGG "
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
      chunk = "                " \
              "AAAAAAAAAAAAAAA " \
              "BB  MM       HH " \
              "CC  LL  OO   GG " \
              "DD  II  PP   FF " \
              "EEEEEEEEEEEEEEE " \
              "                "
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
              "BBBBBBBBBBBBBB C" \
              "DDDDD       EE F" \
              "I             GG" \
              "HHHHHHHHHHHHHHHH" \
              "                " \
              "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABDIHGFCA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}, {x: 0, y: 3}, {x: 0, y: 4}, {x: 15, y: 4}, {x: 15, y: 3}, {x: 15, y: 2}, {x: 15, y: 1}, {x: 15, y: 0}],
                                    inner: [[{x: 4, y: 2}, {x: 12, y: 2}, {x: 13, y: 2}, {x: 13, y: 1}, {x: 15, y: 1}, {x: 15, y: 2}, {x: 14, y: 3}, {x: 0, y: 3}]]}])
    end

    it "scans 2 holed polygon outer full" do
      chunk = "AAAAAAAAAAAAAAAA" \
               "BBBBB  NNNNNNNNN" \
               "CCCC      MMMMMM" \
               "DDD        LLLLL" \
               "EEEE      IIIIII" \
               "FFFFFFF  HHHHHHH" \
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
               "BBBBB  NNNNNNNNN" \
               "CCCC      MMMMMM" \
               "DDD        LLLLL" \
               "EEEE      IIIIII" \
               "FFFFFFF  HHHHHHH" \
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
      chunk = "  AAAAAAAAAAAA  " \
                " BB  MMMMMMMMMM " \
                " CC  LL       N " \
                " DDDDDD   SS  O " \
                " EE   II  RR  P " \
                "  FF  HHH    QQ " \
                "   GGGGGGGGGGG  "
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
      chunk = "        AAAAAA                 " \
              "BBBBB  CCCCCCCC                " \
              " DDDDD  EE FFFF                " \
              " GGGGG  HHHH III               " \
              " JJJJJJJJJJJJ KKK              " \
              "    LLLLLLLLLL MM              " \
              "    NNN OOOOOOOOOO             "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 31), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ACEHJGDBDGJLNLOMKIFCA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to eq([{outer: [{x: 8, y: 0}, {x: 7, y: 1}, {x: 8, y: 2}, {x: 8, y: 3}, {x: 5, y: 3}, {x: 5, y: 2}, {x: 4, y: 1}, {x: 0, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 4, y: 5}, {x: 4, y: 6}, {x: 6, y: 6}, {x: 8, y: 6}, {x: 17, y: 6}, {x: 16, y: 5}, {x: 16, y: 4}, {x: 15, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 13, y: 0}], inner: [[{x: 9, y: 2}, {x: 11, y: 2}], [{x: 15, y: 5}, {x: 13, y: 5}, {x: 12, y: 4}, {x: 11, y: 3}, {x: 13, y: 3}, {x: 14, y: 4}]]}])
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
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {treemap: true, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFNPQGHLMLIGQPNFEDLMA-RSR")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 1]])
      expect(result.points).to eq([{outer: [{x: 2, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 1, y: 5}, {x: 1, y: 6}, {x: 1, y: 7}, {x: 1, y: 8}, {x: 1, y: 9}, {x: 1, y: 10}, {x: 2, y: 11}, {x: 3, y: 12}, {x: 14, y: 12}, {x: 14, y: 11}, {x: 14, y: 10}, {x: 14, y: 9}, {x: 14, y: 8}, {x: 14, y: 7}, {x: 14, y: 6}, {x: 14, y: 5}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 14, y: 2}, {x: 14, y: 1}, {x: 13, y: 0}], inner: [[{x: 2, y: 1}, {x: 5, y: 1}, {x: 5, y: 2}, {x: 2, y: 2}], [{x: 7, y: 5}, {x: 14, y: 5}, {x: 14, y: 6}, {x: 14, y: 7}, {x: 14, y: 8}, {x: 8, y: 8}, {x: 8, y: 7}, {x: 8, y: 6}], [{x: 2, y: 10}, {x: 6, y: 10}, {x: 6, y: 11}, {x: 3, y: 11}]]}, {outer: [{x: 11, y: 6}, {x: 11, y: 7}, {x: 12, y: 7}, {x: 12, y: 6}], inner: []}])
    end

    it "was a failing case" do
      chunk = "  1       1 1      " \
                "   1    1          " \
                "   1 11 1111 1   1 " \
                "11111  11111111  1 " \
                " 11111  11 1111 1  " \
                " 11111  1111 111  1" \
                " 111111111111 111  " \
                "  1 1111111111 11  " \
                "1   111 CCCCCCCCCC " \
                "11   AAAA  BBBB 111" \
                "11111 DDDDDD  11111" \
                "111     1111111 111" \
                "1111  11111111 1111" \
                "1111 11111   111111" \
                "1111 111  111111111" \
                "  111111111111     " \
                "111111 11111     1 " \
                "1111111111111111111"
      dest = @bitmap_class.new(chunk, 19)
      dest.clear(" ")
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 19), @matcher, dest, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("1111111111AD1111111111111111111111111111111C1111111111111111111-111")
      expect(result.metadata[:groups]).to eq(2)
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
                "BB                 TT" \
                "CC 333333333333333 SS" \
                "DD 22           44 RR" \
                "EE 11   WWWWW   55 QQ" \
                "FF ZZZZZZ   $   66 PP" \
                "GG YY   %%%%%   77 OO" \
                "HH XX           88 NN" \
                "II VVVVV     99999 MM" \
                "JJ    UU     !!    LL" \
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
      chunk = "    AAAAAAAAAA     " \
                "    BBB CCCCCCCCCC " \
                "     DDDD  EEEE FFF" \
                "      GGGGGG  HHHHH" \
                "        IIIIIII LLL"
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
      chunk = "    AAAAAAAAAA     " \
                "    BBB CCCCCCCCCC " \
                "     DDDD  EEEE FFF" \
                "      GGGGGG  HHHHH" \
                "        IIIIIII LLL"
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
      chunk = "        AAAAAA                 " \
               "BBBBB  CCCCCCCC                " \
               " DDDDD  EE FFFF                " \
               " GGGGG  HHHH III               " \
               " JJJJJJJJJJJJ KKK              " \
               "    LLLLLLLLLL MM              " \
               "    NNN OOOOOOOOOO             "
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
      chunk = "                                   " \
            "               AAAAA  BBBB         " \
            "              CCCCCCC DDDD   1     " \
            "            EEEE  FFF  GGG  HHH III" \
            "            JJ KKKKK 1     1111 111" \
            "           LL  MMMMMMMM   11111 111" \
            "   111    NN  OOOOOOOOOO  11111   1" \
            "   1111  PPP QQQQ  11111  11111    " \
            "   111  11111    111111 11 111  111" \
            "    11 11111 1 1111111 111 11   111" \
            "      111111 1 111111  111111111111" \
            "     111111111     111 111111111111" \
            "    111111111111 1  111 1 111111111" \
            "   11 111    1 1111111 1111        " \
            "   11 111 1      11111 111        1" \
            "   11 111   1111111111111         1" \
            "   11111111111111111111111111111111" \
            "  11111111    1 11          1111111" \
            "111111111111111111        111111111" \
            "   111111  111111111111111111  1111" \
            " 1  111111  11111111111111    111 1" \
            "1   111111111111111111111 111111  1" \
            "111 11 11111111111111111  11111 1 1" \
            "111   111111111  111 111 1 11111 1 " \
            "111   1111111111 1  11111111  111  " \
            "1     1111 111111   11111 1111111 1" \
            "111   1111 1111111  11111 111111  1" \
            "111   1111  1111111 111111 111 11  " \
            "111 111111 1 11111  1   11111111111" \
            "111   1111     111        1111 111 " \
            " 1    111      111             1   " \
            "     11111   1             1     1 " \
            "    1 111                   11  1  " \
            "       1  1  1  1              1   " \
            " 1   11   1 1 1                    "

      dest = @bitmap_class.new(chunk, 35)
      dest.clear(" ")
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 35), @matcher, dest, {versus: :a, named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ACEJLNP11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111H1H111111111111111111111111OM1MKFCA-BDGDB-I11111I-1111111-1111111111111111111-111-111")
      expect(result.metadata[:groups]).to eq(7)
      expect(result.points).to eq([{outer: [{x: 15, y: 1}, {x: 14, y: 2}, {x: 12, y: 3}, {x: 12, y: 4}, {x: 11, y: 5}, {x: 10, y: 6}, {x: 9, y: 7}, {x: 8, y: 8}, {x: 7, y: 9}, {x: 6, y: 10}, {x: 5, y: 11}, {x: 4, y: 12}, {x: 3, y: 13}, {x: 3, y: 14}, {x: 3, y: 15}, {x: 3, y: 16}, {x: 2, y: 17}, {x: 0, y: 18}, {x: 3, y: 19}, {x: 4, y: 20}, {x: 4, y: 21}, {x: 4, y: 22}, {x: 5, y: 22}, {x: 7, y: 22}, {x: 6, y: 23}, {x: 6, y: 24}, {x: 6, y: 25}, {x: 6, y: 26}, {x: 6, y: 27}, {x: 4, y: 28}, {x: 6, y: 29}, {x: 6, y: 30}, {x: 5, y: 31}, {x: 6, y: 32}, {x: 7, y: 33}, {x: 7, y: 33}, {x: 8, y: 32}, {x: 9, y: 31}, {x: 8, y: 30}, {x: 9, y: 29}, {x: 9, y: 28}, {x: 9, y: 27}, {x: 9, y: 26}, {x: 9, y: 25}, {x: 11, y: 25}, {x: 11, y: 26}, {x: 12, y: 27}, {x: 13, y: 28}, {x: 15, y: 29}, {x: 15, y: 30}, {x: 17, y: 30}, {x: 17, y: 29}, {x: 17, y: 28}, {x: 18, y: 27}, {x: 17, y: 26}, {x: 16, y: 25}, {x: 15, y: 24}, {x: 14, y: 23}, {x: 17, y: 23}, {x: 17, y: 24}, {x: 17, y: 24}, {x: 19, y: 23}, {x: 21, y: 23}, {x: 20, y: 24}, {x: 20, y: 25}, {x: 20, y: 26}, {x: 20, y: 27}, {x: 20, y: 28}, {x: 20, y: 28}, {x: 24, y: 28}, {x: 26, y: 29}, {x: 29, y: 29}, {x: 31, y: 29}, {x: 31, y: 30}, {x: 31, y: 30}, {x: 33, y: 29}, {x: 34, y: 28}, {x: 32, y: 27}, {x: 31, y: 26}, {x: 32, y: 25}, {x: 32, y: 24}, {x: 31, y: 23}, {x: 30, y: 22}, {x: 31, y: 21}, {x: 32, y: 20}, {x: 34, y: 20}, {x: 34, y: 21}, {x: 34, y: 22}, {x: 34, y: 22}, {x: 34, y: 21}, {x: 34, y: 20}, {x: 34, y: 19}, {x: 34, y: 18}, {x: 34, y: 17}, {x: 34, y: 16}, {x: 34, y: 15}, {x: 34, y: 14}, {x: 34, y: 14}, {x: 34, y: 15}, {x: 24, y: 15}, {x: 25, y: 14}, {x: 26, y: 13}, {x: 34, y: 12}, {x: 34, y: 11}, {x: 34, y: 10}, {x: 34, y: 9}, {x: 34, y: 8}, {x: 32, y: 8}, {x: 32, y: 9}, {x: 28, y: 9}, {x: 29, y: 8}, {x: 30, y: 7}, {x: 30, y: 6}, {x: 30, y: 5}, {x: 30, y: 4}, {x: 30, y: 3}, {x: 29, y: 2}, {x: 29, y: 2}, {x: 28, y: 3}, {x: 27, y: 4}, {x: 26, y: 5}, {x: 26, y: 6}, {x: 26, y: 7}, {x: 27, y: 8}, {x: 27, y: 9}, {x: 25, y: 9}, {x: 25, y: 8}, {x: 24, y: 8}, {x: 23, y: 9}, {x: 23, y: 10}, {x: 23, y: 11}, {x: 24, y: 12}, {x: 23, y: 13}, {x: 23, y: 14}, {x: 21, y: 14}, {x: 21, y: 13}, {x: 22, y: 12}, {x: 21, y: 11}, {x: 20, y: 10}, {x: 21, y: 9}, {x: 22, y: 8}, {x: 23, y: 7}, {x: 23, y: 6}, {x: 22, y: 5}, {x: 21, y: 4}, {x: 21, y: 4}, {x: 19, y: 4}, {x: 20, y: 3}, {x: 20, y: 2}, {x: 19, y: 1}], inner: [[{x: 13, y: 4}, {x: 15, y: 4}, {x: 15, y: 5}, {x: 14, y: 6}, {x: 13, y: 7}, {x: 16, y: 7}, {x: 19, y: 7}, {x: 17, y: 8}, {x: 15, y: 9}, {x: 15, y: 10}, {x: 19, y: 11}, {x: 20, y: 12}, {x: 17, y: 12}, {x: 17, y: 12}, {x: 15, y: 12}, {x: 13, y: 11}, {x: 13, y: 10}, {x: 13, y: 9}, {x: 13, y: 9}, {x: 13, y: 10}, {x: 11, y: 10}, {x: 11, y: 9}, {x: 12, y: 8}, {x: 11, y: 7}, {x: 11, y: 6}, {x: 12, y: 5}], [{x: 4, y: 13}, {x: 6, y: 13}, {x: 6, y: 14}, {x: 6, y: 15}, {x: 4, y: 15}, {x: 4, y: 14}], [{x: 9, y: 17}, {x: 14, y: 17}], [{x: 8, y: 19}, {x: 11, y: 19}, {x: 12, y: 20}, {x: 9, y: 20}], [{x: 23, y: 23}, {x: 23, y: 22}, {x: 24, y: 21}, {x: 25, y: 20}, {x: 28, y: 19}, {x: 31, y: 19}, {x: 30, y: 20}, {x: 26, y: 21}, {x: 26, y: 22}, {x: 27, y: 23}, {x: 25, y: 23}, {x: 25, y: 23}], [{x: 24, y: 25}, {x: 26, y: 25}, {x: 26, y: 26}, {x: 27, y: 27}, {x: 25, y: 27}, {x: 24, y: 26}], [{x: 31, y: 27}, {x: 29, y: 27}], [{x: 30, y: 24}, {x: 27, y: 24}], [{x: 28, y: 17}, {x: 26, y: 18}, {x: 17, y: 18}, {x: 17, y: 17}], [{x: 26, y: 12}, {x: 24, y: 12}], [{x: 17, y: 14}, {x: 12, y: 15}, {x: 8, y: 15}, {x: 8, y: 14}, {x: 8, y: 13}, {x: 13, y: 13}, {x: 13, y: 13}, {x: 15, y: 13}], [{x: 18, y: 3}, {x: 15, y: 3}], [{x: 14, y: 17}, {x: 16, y: 17}]]}, {outer: [{x: 22, y: 1}, {x: 22, y: 2}, {x: 23, y: 3}, {x: 25, y: 3}, {x: 25, y: 2}, {x: 25, y: 1}], inner: []}, {outer: [{x: 32, y: 3}, {x: 32, y: 4}, {x: 32, y: 5}, {x: 34, y: 6}, {x: 34, y: 6}, {x: 34, y: 5}, {x: 34, y: 4}, {x: 34, y: 3}], inner: []}, {outer: [{x: 3, y: 6}, {x: 3, y: 7}, {x: 3, y: 8}, {x: 4, y: 9}, {x: 5, y: 9}, {x: 5, y: 8}, {x: 6, y: 7}, {x: 5, y: 6}], inner: []}, {outer: [{x: 0, y: 21}, {x: 0, y: 22}, {x: 0, y: 23}, {x: 0, y: 24}, {x: 0, y: 25}, {x: 0, y: 26}, {x: 0, y: 27}, {x: 0, y: 28}, {x: 0, y: 29}, {x: 1, y: 30}, {x: 1, y: 30}, {x: 2, y: 29}, {x: 2, y: 28}, {x: 2, y: 27}, {x: 2, y: 26}, {x: 0, y: 25}, {x: 2, y: 24}, {x: 2, y: 23}, {x: 2, y: 22}, {x: 0, y: 21}], inner: []}, {outer: [{x: 34, y: 25}, {x: 34, y: 26}, {x: 34, y: 26}, {x: 34, y: 25}], inner: []}, {outer: [{x: 10, y: 33}, {x: 10, y: 34}, {x: 10, y: 34}, {x: 10, y: 33}], inner: []}])
    end
  end
end
