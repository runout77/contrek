RSpec.shared_examples "treemap" do
  describe "simple cases" do
    it "scans 3 level" do
      chunk = "AAAAAAAAAAAAAAA0000000" \
              "B0000000000000C0000000" \
              "D0EEEEEEEEEEE0F0000000" \
              "G0H000000000I0L0000000" \
              "M0N0OOOOOOO0P0Q0000000" \
              "R0S000000000T0U0000000" \
              "V0XXXXXXXXXXX0Y0000000" \
              "W0000000000000Z0000000" \
              "1111111111111110000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(3)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0]])
    end
    it "scans 3 level" do
      chunk = "AAAAAAAAAAAAAAA0000000" \
              "B0000000000000C0000000" \
              "D0EEEEEEEEEEE0F0000000" \
              "G0H000000000I0L0000000" \
              "M0N0OO022030P0Q0000000" \
              "R0S000000000T0U0000000" \
              "V0XXXXXXXXXXX0Y0000000" \
              "W0000000000000Z0000000" \
              "1111111111111110000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(5)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0],
        [1, 0],
        [1, 0]])
    end
    it "scans 3 level plus" do
      chunk = "AAAAAAAAA0000000000000" \
              "B0000000C0000220000000" \
              "D0EEEEE0F0000000000000" \
              "G0H000I0L0000000000000" \
              "M0N0O0P0Q0000000000000" \
              "R0S000T0U0000000000000" \
              "V0XXXXX0Y0000000000000" \
              "W0000000Z0000000000000" \
              "1111111110000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(4)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [0, 0],
        [2, 0]])
    end
    it "scans 3 level plus 2" do
      chunk = "AAAAAAAAA0000000000000" \
              "B0000000C0000220000000" \
              "D0EEEEE0F0000000000000" \
              "G0H000I0L0000333333300" \
              "M0N0O0P0Q0000300000300" \
              "R0S000T0U0000304400300" \
              "V0XXXXX0Y0000300000300" \
              "W0000000Z0000333333300" \
              "1111111110000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(6)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [0, 0],
        [-1, -1],
        [2, 0],
        [3, 0]])
    end
    it "scans 3 level plus 3" do
      chunk = "AAAAAAAAA0000000000000" \
              "B0000000C0000220000000" \
              "D0EEEEE0F0000000000000" \
              "G0H000I0L0000333333300" \
              "M0N0O0P0Q0000300000300" \
              "R0S000T0U0000304400300" \
              "V0XXXXX0Y0000300000300" \
              "W0000000Z0000333333300" \
              "1111111110000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {versus: :o, treemap: true}).process_info
      expect(result[:groups]).to eq(6)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [0, 0],
        [-1, -1],
        [2, 0],
        [3, 0]])
    end

    it "scans 3 level plus 4" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "BBBBBB000000000BBBBBBB" \
              "CCCCCC0000GGG00EEEEEEE" \
              "DDDDDD000000000FFFFFFF"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(2)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1]])
    end

    it "scans 3 level plus 5" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X00000000000000000000A" \
              "A0000AAAAAAAAAAA00000A" \
              "A0000A000000000A00000A" \
              "Y0000C00BBBBB00D00000A" \
              "A0000A000000000A00000A" \
              "AAAAAA000000000AAAAAAA" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(2)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1]])
    end

    it "scans 3 level plus 6" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X00000000000000000000A" \
              "A0000AAAAAAAAAAA00000A" \
              "A0000A000000000A00000A" \
              "Y0000C00BBBBB00D00000A" \
              "A0000A000000000A00000A" \
              "AAAAAA000000000AAAAAAA" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {versus: :o, treemap: true}).process_info
      expect(result[:groups]).to eq(2)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1]])
    end
    it "scans 3 level plus 7" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X00000000000000000000A" \
              "A0000AAAAAAAAAAA00000A" \
              "A0000A000000000A00000A" \
              "Y0000C00BB0NN00D00000A" \
              "A0000A000000000A00000A" \
              "AAAAAA000000000AAAAAAA" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(3)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [-1, -1]])
    end
    it "scans 3 level plus 8" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X00000000000000000000A" \
              "A0000AAAAAAAAAAA00000A" \
              "A0000A000000000A00000A" \
              "Y0ZZ0C00BB0NN00D00110A" \
              "A0000A000000000A00000A" \
              "AAAAAA000000000AAAAAAA" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(5)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [-1, -1],
        [-1, -1],
        [0, 0]])
    end
    it "scans 3 level plus 9" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X00000000000000000000A" \
              "A0000AAAAAAAAAAAAAAAAA" \
              "A0000A0000000000000000" \
              "Y0ZZ0C00BB0NN00DDDDDDD" \
              "A0000A000000000A00000A" \
              "AAAAAA000000000A01100A" \
              "000000000000000A00000A" \
              "000000000000000AAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(6)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [-1, -1],
        [-1, -1],
        [-1, -1],
        [4, 0]])
    end
    it "scans 3 level plus 10" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "B00000000000000000000P" \
              "C0000QQQQQQQQQQQ00000O" \
              "D0000R000000000X00000N" \
              "E0000S00YYYYY00W00000M" \
              "F0000T000000000V00000L" \
              "G0000UUUUUUUUUUU00000K" \
              "H00000000000000000000J" \
              "IIIIIIIIIIIIIIIIIIIIII"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(3)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0]])
    end
    it "scans 3 level plus 11" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A00000000000000000000A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0B0000000000000000B0A" \
              "A0B0CCCCCC00EE00FF0B0A" \
              "A0B0C0000C000000000B0A" \
              "A0B0C0DD0C0GG00HH00B0A" \
              "A0B0C0000C000000000B0A" \
              "A0B0CCCCCC000000000B0A" \
              "A0B0000000000000000B0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A00000000000000000000A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(8)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0],
        [1, 0],
        [1, 0],
        [2, 0],
        [1, 0],
        [1, 0]])
    end
    it "scans 3 level plus 12" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A00000000000000000000A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBDDDDDBB0A" \
              "A0XXX0000BBBBD000DBB0A" \
              "A0FFF0DD0GGGGD0E0DBB0A" \
              "A0BBB0000BBBBD000DBB0A" \
              "A0BBBBBBBBBBBDDDDDBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A00000000000000000000A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(4)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0],
        [1, 1]])
    end
    it "scans 3 level plus 13" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A00000000000000000000A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBDDDDDBB0A" \
              "A0XXX0000BBBBD000YBB0A" \
              "A0FFF0DD0GGGGD0E0DBB0A" \
              "A0WBB0000BBBBD000DBB0A" \
              "A0BBBBBBBBBBBDDDDDBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A00000000000000000000A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {versus: :o, treemap: true}).process_info
      expect(result[:groups]).to eq(4)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 1],
        [1, 0]])
    end
    it "scans 3 level plus 14" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A00000000000000000000A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBB0000BBBBBBBBBBB0A" \
              "A0BBB0DD0BBBBBBBBBBB0A" \
              "A0BBB0000BBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A00000000000000000000A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(3)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0]])
    end
    it "scans 3 level plus 15" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A00000000000000000000A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A0B0000000000000000B0A" \
              "A0B00EE00HH0CCCCCC0B0A" \
              "A0B000000000C0000C0B0A" \
              "A0B00FF00GG0C0DD0C0B0A" \
              "A0B000000000C0000C0B0A" \
              "A0B000000000CCCCCC0B0A" \
              "A0B0000000000000000B0A" \
              "A0BBBBBBBBBBBBBBBBBB0A" \
              "A00000000000000000000A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(8)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0],
        [1, 0],
        [1, 0],
        [1, 0],
        [1, 0],
        [4, 0]])
    end
  end
end
