# frozen_string_literal: true

RSpec.shared_examples "simples" do
  describe "simples" do
    it "detects only one sequence" do
      chunk = "                " \
                 "      AAAA      " \
                 "                " \
                 "                " \
                 "                " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("A")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(7)
      expect(result.points).to match_expected_json
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
      expect(result.metadata[:named_sequence]).to eq("A-B-C")
      expect(result.metadata[:groups]).to eq(3)
      expect(result.metadata[:versus]).to eq(:a)
      expect(result.points).to match_expected_json
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
    it "is full" do
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
      expect(result.points).to match_expected_json
    end
    it "is full ask for compression" do
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
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFGQPONMA-SRS")
      expect(result.metadata[:groups]).to eq(2)
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
      pf = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true})
      result = pf.process_info
      expect(result.metadata[:named_sequence]).to eq("ABCDEFNPQGHLMLIGQPNFEDLMA-RSR")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to match_expected_json
    end

    it "is full ask for compression and scale coords" do
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
    end

    it "is triangle full with compression" do
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json
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
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "finds two blocks but only one polygon" do
      chunk = "  AAAAAAAAAAAA  " \
                 "  H          B  " \
                 "  G   III    C  " \
                 "  F          D  " \
                 "  EEEEEEEEEEEE  " \
                 "                " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("AHGFEDCBA-I")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to match_expected_json
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
      expect(result.metadata[:named_sequence]).to eq("AHGFEDCBA-I")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to match_expected_json
    end

    it "finds one polygon ignores I and L" do
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
      expect(result.points).to match_expected_json
    end

    it "finds three blocks two polygons" do
      chunk = "                " \
                 "   AAAA   CCCC  " \
                 "   BBBB   DDDD  " \
                 "                " \
                 "                " \
                 "       EEE      " \
                 "                "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 16), @matcher, nil, {named_sequences: true}).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA-CDC-E")
      expect(result.metadata[:groups]).to eq(3)
      expect(result.points).to match_expected_json
    end

    it "returns bounds" do
      chunk = "                " \
              "   AAAAAAAAA    " \
              "   AAAAAAAAA    " \
              "   AAAAAAAAA    " \
              "                " \
              "       EEE      " \
              "       EEE      " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {named_sequences: true, bounds: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("AAAAA-EEE")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to match_expected_json
    end
  end
end
