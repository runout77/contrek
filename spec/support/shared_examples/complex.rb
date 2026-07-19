# frozen_string_literal: true

require "yaml"
RSpec.shared_examples "complex" do
  describe "complex" do
    it "faster indexing" do
      chunk = "                                                                                                                                                                                                        " \
               "A B C D E F G H I J K L M N O P Q R S T U V W X Y A B C D E F G H I J K L M N O P Q R S T U V W X Y A B C D E F G H I J K L M N O P Q R S T U V W X Y A B C D E F G H I J K L M N O P Q R S T U V W X Y " \
               "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" \
               "                                                                                                                                                                                                        "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 200), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZAZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZAZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZAZYZXZWZVZUZTZSZRZQZPZOZNZMZLZKZJZIZHZGZFZEZDZCZBZA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json
    end

    it "scan complex tree" do
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
    end

    it "scans 3 holed polygon" do
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
    end

    it "scans 2 holed polygon complex" do
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
      expect(result.points).to match_expected_json
    end

    it "loses some mia" do
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
    end

    it "scans 2 holed polygon outer full clockwise" do
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
      expect(result.points).to match_expected_json
    end

    it "problem" do
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
      expect(result.points).to match_expected_json
    end

    it "j form" do
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
      expect(result.points).to match_expected_json
    end

    it "problem 2" do
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
      expect(result.points).to match_expected_json
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
      expect(result.metadata[:named_sequence]).to eq("1-1-1-1111111111AD1111111111111111111111111111111C1111111111111111111-1-111-1-1")
      expect(result.metadata[:groups]).to eq(8)
      expect(result.points).to match_expected_json
    end

    it "scans labirinth" do
      filename = "labyrinth2.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(@png_not_matcher_color)
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a, named_sequences: true, compress: {uniq: true, linear: true}})
      result = polygonfinder.process_info
      expect(result.points).to match_expected_json
    end

    it "scans sample 270x257" do
      filename = "sample_270x257.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(@png_not_matcher_color)
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a, named_sequences: true, compress: {uniq: true, linear: true}})
      result = polygonfinder.process_info
      expect(result.points).to match_expected_json
    end

    it "scans sample 254x250" do
      filename = "sample_254x250.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      rgb_matcher = @png_not_matcher.new(@png_not_matcher_color)
      polygonfinder = @polygon_finder_class.new(png_bitmap, rgb_matcher, nil, {versus: :a})
      result = polygonfinder.process_info
      expect(result.points).to match_expected_json
    end

    it "works like a charm" do
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
      expect(result.points).to match_expected_json
    end

    it "was a failing case 2" do
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
      expect(result.points).to match_expected_json
    end

    it "was a failing case 3" do
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
      expect(result.points).to match_expected_json
    end

    it "was a failing case 4" do
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
      expect(result.points).to match_expected_json
    end

    it "multiple sequence" do
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
      expect(result.metadata[:named_sequence]).to eq("ACEJLNP11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111H1H111111111111111111111111OM1MKFCA-BDGDB-I11111I-1111111-1-1-1111111111111111111-1-1-111-1-1-1-1-1-1-1-111-1-1-1-1-1-1-1")
      expect(result.metadata[:groups]).to eq(25)
      expect(result.points).to match_expected_json
    end
  end
end
