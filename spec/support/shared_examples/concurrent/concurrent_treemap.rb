# frozen_string_literal: true

RSpec.shared_examples "concurrent_treemap" do
  describe "concurrent_treemap" do
    it "case 1" do
      chunk = " 000000    000000 " \
              " 0    0    0    0 " \
              " 0 00 0    0 00 0 " \
              " 0 00 0    0 00 0 " \
              " 0    0    0    0 " \
              " 000000    000000 "
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 18),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [0, 0], [1, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [-1, -1], [2, 0]])
    end

    it "case 2" do
      chunk = "0000000000000000" \
              "00            00" \
              "00   000000   00" \
              "00   000000   00" \
              "00            00" \
              "0000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 3" do
      chunk = "0000000000000000" \
              "00            00" \
              "0000000000000000" \
              "00              " \
              "00   000000   00" \
              "00   000000   00" \
              "00            00" \
              "0000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 4" do
      chunk = "0000000000000000" \
              "00            00" \
              "00        000 00" \
              "00        000 00" \
              "00            00" \
              "0000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 5" do
      chunk = "0000000000000000" \
              "00            00" \
              "00 000        00" \
              "00 000        00" \
              "00            00" \
              "0000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 6" do
      chunk = "0000000000000000" \
              "00            00" \
              "00 000000000  00" \
              "00 000000000  00" \
              "00 0       0  00" \
              "00 0 00000 0  00" \
              "00 0 00000 0  00" \
              "00 0       0  00" \
              "00 000000000  00" \
              "00 000000000  00" \
              "00            00" \
              "0000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [1, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 7" do
      chunk = "0000000000000000" \
              "00            00" \
              "00 0000000000 00" \
              "00 0        0 00" \
              "00 0     00 0 00" \
              "00 0     00 0 00" \
              "00 0        0 00" \
              "00 0000000000 00" \
              "00            00" \
              "0000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [1, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 8" do
      chunk = "000000000000000000000000" \
              "000000000000000000000000" \
              "00                    00" \
              "00 1000000000         00" \
              "00 0        0 200000  00" \
              "00 0        0 000000  00" \
              "00 0 300000 0         00" \
              "00 0 000000 0 0000000000" \
              "00 0        0 00        " \
              "00 0000000000 00  4000  " \
              "00            00  0000  " \
              "0000000000000000        "
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 24),
        @matcher,
        nil,
        {named_sequences: true, versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("00000000000000000000000-1000000000001-202-303-404")
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 0], [1, 0], [-1, -1]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 24),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [1, 0], [0, 0], [-1, -1]])
    end

    it "case 9" do
      chunk = "000000000000000000000000" \
              "000000000000000000000000" \
              "00                    00" \
              "00 11111 222222 33333 00" \
              "00 11111 222222 33333 00" \
              "00                    00" \
              "00     0000000000     00" \
              "00 444 00      00 666 00" \
              "00 444 00 5555 00 666 00" \
              "00     00 5555 00     00" \
              "000000000      000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 24),
        @matcher,
        nil,
        {named_sequences: true, versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("00000000000000000000000000000-111-222-333-444-666-555")
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [-1, -1]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 24),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 0], [0, 0], [-1, -1], [0, 0], [0, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 24),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 0], [0, 0], [-1, -1], [0, 0], [0, 0]])
    end

    it "case 10" do
      chunk = "000000000000000000000000" \
              "000000000000000000000000" \
              "00                    00" \
              "00 1000000000     22  00" \
              "00 0000000000     22  00" \
              "00                    00" \
              "00           333      00" \
              "00           333      00" \
              "00                    00" \
              "000000000000000000000000" \
              "000000000000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 24),
        @matcher,
        nil,
        {named_sequences: true, versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 0], [0, 0]])
      expect(result.metadata[:named_sequence]).to eq("000000000000000000000-101-222-333")

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 24),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 0], [0, 0]])
    end

    it "case 11" do
      chunk = "000000000000000000000000" \
              "000000000000000000000000" \
              "00                    00" \
              "00   22222222222222   00" \
              "00   22222222222222   00" \
              "00   22          22   00" \
              "00   22  333333  22   00" \
              "00   22  333333  22   00" \
              "00   22          22   00" \
              "00   22222222222222   00" \
              "00   22222222222222   00" \
              "00                    00" \
              "000000000000000000000000" \
              "000000000000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 24),
        @matcher,
        nil,
        {named_sequences: true, versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [1, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 24),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [1, 0]])
    end

    it "case 12 (resolve parent nil)" do
      chunk = "       000000000" \
              "       000000000" \
              "       00     00" \
              "     0000 000 00" \
              "     0000 000 00" \
              "       00     00" \
              "       000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 13" do
      chunk = "000000000000000000000000000000000000000000000000" \
              "000000000000000000000000000000000000000000000000" \
              "00                    0000                    00" \
              "00 22222222222222222  0000 7777777777777777   00" \
              "00 22222222222222222  0000 7777777777777777   00" \
              "00 22             22  0000 77            77   00" \
              "00 22 11 33333333 22  0000 77 55 666666  77   00" \
              "00 22 11 33333    22  0000 77 55 666666  77   00" \
              "00 22           2222  0000 77            77   00" \
              "00 22222222222222     0000 7777777777777777   00" \
              "00 22222222222222 444 0000 7777777777777777   00" \
              "00                444 0000                    00" \
              "00000000000000000 444 00000000000000000000000000" \
              "00000000000000000     00000000000000000000000000" \
              "000000000000000000000000000000000000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 48),
        @matcher,
        nil,
        {named_sequences: true, versus: :a, treemap: true}
      ).process_info
      # 00000000000000000000000000000-222222222222222-777777777777777-111-333-555-666-44444
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 1], [1, 0], [1, 0], [2, 0], [2, 0], [0, 0]])
      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 48),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      # 0-2-1-3-4-7-5-6
      expect(c_result.points).to match_expected_json
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [1, 0], [1, 0], [0, 0], [0, 1], [5, 0], [5, 0]])
    end

    it "case 14" do
      chunk = "000000000000000000000000" \
              "000000000000000000000000" \
              "00         00         00" \
              "00 1111111 00 2222222 00" \
              "00 1111111 00 2222222 00" \
              "00         00         00" \
              "000000000000000000000000" \
              "000000000000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 24),
        @matcher,
        nil,
        {named_sequences: true, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 1]])
      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 24),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 15" do
      chunk = "00000000000000000000000000" \
              "00000000000000000000000000" \
              "00          00    00    00" \
              "00 1111111  00 22 00 33 00" \
              "00 1111111  00 22 00 33 00" \
              "00          00    00    00" \
              "00000000000000000000000000" \
              "00000000000000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 26),
        @matcher,
        nil,
        {named_sequences: true, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      # 0 1 2 3
      # holes 0 => 0 - 1 - 2 (1-2-3)
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 2], [0, 1]])
      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 26),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      # 0 1 2 3
      # holes 0 => 0 - 2 - 1 (1-3-2)
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 1], [0, 2]])
    end

    it "case 16" do
      chunk = "000000000000000000000000000000" \
              "000000000000000000000000000000" \
              "00                          00" \
              "00             222222222222 00" \
              "00             222222222222 00" \
              "00             22        22 00" \
              "00             22 333333 22 00" \
              "00             22 33  33 22 00" \
              "00             22 33  33 22 00" \
              "00             22 333333 22 00" \
              "00             22        22 00" \
              "00             222222222222 00" \
              "00             222222222222 00" \
              "00                          00" \
              "000000000000000000000000000000" \
              "000000000000000000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 30),
        @matcher,
        nil,
        {named_sequences: true, versus: :a, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [1, 0]])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 30),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [1, 0]])
    end

    it "case 17" do
      chunk = "A0000000 B0000000 C0000000" \
              "00000000 00000000 00000000" \
              "00    00 00    00 00    00" \
              "00 11 00 00 22 00 00 33 00" \
              "00 11 00 00 22 00 00 33 00" \
              "00    00 00    00 00    00" \
              "00000000 00000000 00000000" \
              "00000000 00000000 00000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 26),
        @matcher,
        nil,
        {named_sequences: true, versus: :a, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [-1, -1], [0, 0], [1, 0], [2, 0]])
      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 26),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      # A 1 B 2 C 3
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [-1, -1], [2, 0], [-1, -1], [4, 0]])
    end

    it "case 18" do
      chunk = "000000000000000000000000000000000000000000000000000000000000" \
              "000000000000000000000000000000000000000000000000000000000000" \
              "0                                                          0" \
              "0 22222222222222222222222222222222222222222222222222222222 0" \
              "0 22222222222222222222222222222222222222222222222222222222 0" \
              "0 2                                                      2 0" \
              "0 2 3333333333333333333333333333333333333333333333333333 2 0" \
              "0 2 3333333333333333333333333333333333333333333333333333 2 0" \
              "0 2 3                                                  3 2 0" \
              "0 2 3 444444444444444444444444444444444444444444444444 3 2 0" \
              "0 2 3 444444444444444444444444444444444444444444444444 3 2 0" \
              "0 2 3 4                                              4 3 2 0" \
              "0 2 3 4 55555555555555555555555555555555555555555555 4 3 2 0" \
              "0 2 3 4 55555555555555555555555555555555555555555555 4 3 2 0" \
              "0 2 3 4 5                                          5 4 3 2 0" \
              "0 2 3 4 5 6666666666666666666666666666666666666666 5 4 3 2 0" \
              "0 2 3 4 5 6666666666666666666666666666666666666666 5 4 3 2 0" \
              "0 2 3 4 5 6                                      6 5 4 3 2 0" \
              "0 2 3 4 5 6 777777777777777777777777777777777777 6 5 4 4 3 0" \
              "0 2 3 4 5 6 777777777777777777777777777777777777 6 5 4 4 3 0" \
              "0 2 3 4 5 6 7                                  7 6 5 4 3 2 0" \
              "0 2 3 4 5 6 7 8888 9999 1111111111 AAAAAAAAAAA 7 6 5 4 3 2 0" \
              "0 2 3 4 5 6 7 8  8 9999 1        1 A         A 7 6 5 4 3 2 0" \
              "0 2 3 4 5 6 7 8888 9999 1111111111 AAAAAAAAAAA 7 6 5 4 3 2 0" \
              "0 2 3 4 5 6 7                                  7 6 5 4 3 2 0" \
              "0 2 3 4 5 6 777777777777777777777777777777777777 6 5 4 4 3 0" \
              "0 2 3 4 5 6 777777777777777777777777777777777777 6 5 4 4 3 0" \
              "0 2 3 4 5 6                                      6 5 4 3 2 0" \
              "0 2 3 4 5 6666666666666666666666666666666666666666 5 4 3 2 0" \
              "0 2 3 4 5 6666666666666666666666666666666666666666 5 4 3 2 0" \
              "0 2 3 4 5                                          5 4 3 2 0" \
              "0 2 3 4 55555555555555555555555555555555555555555555 4 3 2 0" \
              "0 2 3 4 55555555555555555555555555555555555555555555 4 3 2 0" \
              "0 2 3 4                                              4 3 2 0" \
              "0 2 3 444444444444444444444444444444444444444444444444 3 2 0" \
              "0 2 3 444444444444444444444444444444444444444444444444 3 2 0" \
              "0 2 3                                                  3 2 0" \
              "0 2 3333333333333333333333333333333333333333333333333333 2 0" \
              "0 2 3333333333333333333333333333333333333333333333333333 2 0" \
              "0 2                                                      2 0" \
              "0 22222222222222222222222222222222222222222222222222222222 0" \
              "0 22222222222222222222222222222222222222222222222222222222 0" \
              "0                                                          0" \
              "000000000000000000000000000000000000000000000000000000000000" \
              "000000000000000000000000000000000000000000000000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 60),
        @matcher,
        nil,
        {named_sequences: true, versus: :a, treemap: true}
      ).process_info
      # 0 2 3 4 5 6 7 8 9 1 A
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [6, 0], [6, 0], [6, 0]])
      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 60),
        matcher: @matcher,
        options: {number_of_tiles: 5, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      # 0 2 3 4 5 6 7 8 9 1 A
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 19" do
      chunk = "000000000000    " \
              "00        00    " \
              "00        00    " \
              "000000000000    " \
              "                " \
              "          000000" \
              "          0    0" \
              "          0 00 0" \
              "          0 00 0" \
              "          0    0" \
              "          000000"

      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [1, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 20" do
      chunk = "0000000000000000" \
              "0000000000000000" \
              "0              0" \
              "0 000000000000 0" \
              "0 000000000000 0" \
              "0 0          0 0" \
              "0 0 00000000 0 0" \
              "0 0 00000000 0 0" \
              "0 0 0      0 0 0" \
              "0 000 0000 000 0" \
              "0 000 0000 000 0" \
              "0              0" \
              "0000000000000000" \
              "0000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 0]])

      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.metadata[:treemap]).to eq(result.metadata[:treemap])
    end

    it "case 21" do
      chunk = "                  00           " \
              "                 0000          " \
              "                00  00         " \
              "               00    00        " \
              "              0000000000       " \
              "             000000000000      " \
              "            00   0000   00     " \
              "           00  00000000  00    " \
              "          00  0000000000  00   " \
              "         00  00        00  00  " \
              "        00  00  111111  00  00 " \
              "       00  00  11111111  00  00" \
              "       00  00  11    11  00  00" \
              "       00  00  11 22 11  00  00" \
              "       00  00  11 22 11  00  00" \
              "       00  00  11    11  00  00" \
              "       00  00  11111111  00  00" \
              "        00  00  111111  00  00 " \
              "         00  00        00  00  " \
              "          00  0000000000  00   " \
              "           00  00000000  00    " \
              "            00          00     " \
              "             000000000000      " \
              "              0000000000       "
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 31),
        @matcher,
        nil,
        {treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 2], [1, 0]])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 31),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      # 0=>0 1=>1 2=>2
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 1], [1, 0]])
    end

    it "case 22" do
      chunk = "0000000000000000" \
              "00            00" \
              "0000000000000000" \
              "00              " \
              "00 0000000000000" \
              "00 00         00" \
              "00 00 0000 00 00" \
              "00 00 0000 00 00" \
              "00         00 00" \
              "0000000000000 00" \
              "              00" \
              "0000000000000000" \
              "00            00" \
              "0000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [-1, -1]])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [-1, -1]])
    end

    it "case 23" do
      chunk = "0000000000000000" \
              "00            00" \
              "0000000000000000" \
              "00              " \
              "0000000000000000" \
              "00  00        00" \
              "00  00 000 00000" \
              "00  00 000 00   " \
              "00  00     00   " \
              "0000000000000   "

      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 1]])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 2]])
    end

    it "case 24" do
      chunk = "000000000000000000" \
              "00              00" \
              "00  00000000000000" \
              "00  00          00" \
              "00  00 00000    00" \
              "00  00 00000      " \
              "00  00          00" \
              "000000000000000000"

      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 18),
        @matcher,
        nil,
        {versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1]])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1]])
    end

    it "case 25" do
      chunk = "000000000000000000" \
              "00              00" \
              "00  00000000000000" \
              "00  00          00" \
              "00  00 00000    00" \
              "00  00 00000    00" \
              "00  00          00" \
              "000000000000000000"

      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 18),
        @matcher,
        nil,
        {versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 1]])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 1]])
    end

    it "case 26" do
      chunk = "000000000000000000" \
              "00  00          00" \
              "00  00 00000    00" \
              "00  00 00000    00" \
              "00  00          00" \
              "00  00000000000000" \
              "00              00" \
              "000000000000000000"

      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 18),
        @matcher,
        nil,
        {versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0]])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0]])
    end

    it "case 27" do
      chunk = "          000   " \
              "          000   " \
              "                " \
              "0000000000000000" \
              "00            00" \
              "00 000    000 00" \
              "00 000    000 00" \
              "00            00" \
              "0000000000000000" \
              "                " \
              "   000    000   " \
              "   000    000   "
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [1, 0], [1, 0], [-1, -1], [-1, -1]])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [-1, -1], [-1, -1], [0, 0], [-1, -1]])
    end

    it "case 28" do
      chunk = "000000000000000000000000000000000000000000000000" \
              "000000000000000000000000000000000000000000000000" \
              "00                                            00" \
              "00           22222                            00" \
              "00           22222                            00" \
              "00                                            00" \
              "000000000000000000000000000000000000000000000000" \
              "000000000000000000000000000000000000000000000000" \
              "                                                " \
              "   11111                                        " \
              "   11111                                        "
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 48),
        @matcher,
        nil,
        {named_sequences: true, versus: :a, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [-1, -1]])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 48),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [0, 0]])
    end

    it "case 29" do
      chunk = "000000000000000000000000000000000000000000000000" \
              "000000000000000000000000000000000000000000000000" \
              "00                                            00" \
              "00 111111111111111111                         00" \
              "00 111111111111111111                         00" \
              "00 11              11111111111111111111111111100" \
              "00 11 22           11111111111111111111111111100" \
              "00 11 22           11                         00" \
              "00 11              11                         00" \
              "00 111111111111111111                         00" \
              "00 111111111111111111                         00" \
              "00                                            00" \
              "000000000000000000000000000000000000000000000000" \
              "000000000000000000000000000000000000000000000000"
      result = @simple_polygon_finder.new(
        @bitmap_class.new(chunk, 48),
        @matcher,
        nil,
        {named_sequences: true, versus: :a, treemap: true}
      ).process_info
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 1]])
      c_result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 48),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, treemap: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(c_result.points).to match_expected_json(addons: [:o])
      expect(c_result.metadata[:treemap]).to eq([[-1, -1], [0, 1]])
    end
  end
end
