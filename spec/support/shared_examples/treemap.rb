# frozen_string_literal: true

RSpec.shared_examples "treemap" do
  describe "treemap" do
    it "scans 3 level 1" do
      chunk = "AAAAAAAAAAAAAAA       " \
              "B             C       " \
              "D EEEEEEEEEEE F       " \
              "G H         I L       " \
              "G H OOOOOOO I L       " \
              "M N OOOOOOO P Q       " \
              "R S         T U       " \
              "V XXXXXXXXXXX Y       " \
              "W             Z       " \
              "111111111111111       "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(3)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0]])
    end

    it "scans 3 level 2" do
      chunk = "AAAAAAAAAAAAAAA       " \
              "B             C       " \
              "D EEEEEEEEEEE F       " \
              "G H         I L       " \
              "M N    22   P Q       " \
              "M N OO 22 3 P Q       " \
              "R S 00 22 3 T U       " \
              "V X         X Y       " \
              "V XXXXXXXXXXX Y       " \
              "W             Z       " \
              "111111111111111       "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(5)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0],
        [1, 0],
        [1, 0]])
    end

    it "scans 3 level 3" do
      chunk = "AAAAAAAAA             " \
              "B       C    22       " \
              "D EEEEE F    22       " \
              "G H   I L             " \
              "G H O I L             " \
              "M N O P Q             " \
              "R S   T U             " \
              "V XXXXX Y             " \
              "W       Z             " \
              "111111111             "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [0, 0],
        [2, 0]])
    end

    it "scans 3 level 4" do
      chunk = "AAAAAAAAA    22       " \
              "B       C    22       " \
              "D EEEEE F             " \
              "G H   I L    3333333  " \
              "M N O P Q    3     3  " \
              "M N O P Q    3 44  3  " \
              "R S   T U    3 44  3  " \
              "V XXXXX Y    3     3  " \
              "W       Z    3333333  " \
              "111111111             "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(6)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [0, 0],
        [-1, -1],
        [2, 0],
        [3, 0]])
    end

    it "scans 3 level 5" do
      chunk = "AAAAAAAAA    22       " \
              "B       C    22       " \
              "D EEEEE F             " \
              "G H   I L    3333333  " \
              "M N O P Q    3     3  " \
              "M N O P Q    3 44  3  " \
              "R S   T U    3 44  3  " \
              "V XXXXX Y    3     3  " \
              "W       Z    3333333  " \
              "111111111             "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {versus: :o, treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(6)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [0, 0],
        [-1, -1],
        [2, 0],
        [3, 0]])
    end

    it "scans 3 level 6" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "BBBBBB         BBBBBBB" \
              "CCCCCC    GGG  EEEEEEE" \
              "DDDDDD    GGG  FFFFFFF"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(2)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [-1, -1]])
    end

    it "scans 3 level 7" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X                    A" \
              "A    AAAAAAAAAAA     A" \
              "A    A         A     A" \
              "Y    C  BBBBB  D     A" \
              "A    A  BBBBB  A     A" \
              "AAAAAA         AAAAAAA" \
              "                      "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(2)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [-1, -1]])
    end

    it "scans 3 level 8" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X                    A" \
              "A    AAAAAAAAAAA     A" \
              "A    A         A     A" \
              "Y    C  BBBBB  D     A" \
              "A    A  BBBBB  A     A" \
              "AAAAAA         AAAAAAA" \
              "                      "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {versus: :o, treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(2)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [-1, -1]])
    end

    it "scans 3 level 9" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X                    A" \
              "A    AAAAAAAAAAA     A" \
              "A    A         A     A" \
              "Y    C  BB NN  D     A" \
              "A    A  BB NN  A     A" \
              "AAAAAA         AAAAAAA" \
              "                      "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(3)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [-1, -1]])
    end

    it "scans 3 level 10" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X                    A" \
              "A    AAAAAAAAAAA     A" \
              "A    A         A     A" \
              "Y ZZ C  BB NN  D  11 A" \
              "A ZZ A  BB NN  A  11 A" \
              "A    A  BB NN  A     A" \
              "AAAAAA         AAAAAAA" \
              "                      "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(5)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [0, 0],
        [-1, -1],
        [-1, -1],
        [0, 0]])
    end

    it "scans 3 level 11" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X                    A" \
              "A    AAAAAAAAAAAAAAAAA" \
              "A    A                " \
              "Y ZZ C  BB NN  DDDDDDD" \
              "A ZZ A  BB NN  A     A" \
              "A    A         A 11  A" \
              "AAAAAA         A 11  A" \
              "               A     A" \
              "               AAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(6)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [0, 0],
        [-1, -1],
        [-1, -1],
        [-1, -1],
        [4, 0]])
    end

    it "scans 3 level 12" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "B                    P" \
              "C    QQQQQQQQQQQ     O" \
              "D    R         X     N" \
              "E    S  YYYYY  W     M" \
              "E    S  YYYYY  W     M" \
              "F    T         V     L" \
              "G    UUUUUUUUUUU     K" \
              "H                    J" \
              "IIIIIIIIIIIIIIIIIIIIII"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(3)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0]])
    end

    it "scans 3 level 13" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A B                B A" \
              "A B CCCCCC  EE  FF B A" \
              "A B C    C  EE  FF B A" \
              "A B C    C         B A" \
              "A B C DD C GG  HH  B A" \
              "A B C DD C GG  HH  B A" \
              "A B C    C         B A" \
              "A B CCCCCC         B A" \
              "A B                B A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(8)
      expect(result.metadata[:treemap]).to eq([[-1, -1], # A
        [0, 0], # B
        [1, 0], # C
        [1, 0], # E
        [1, 0], # F
        [2, 0], # D
        [1, 0], # G
        [1, 0]]) # H
    end

    it "scans 3 level 14" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBDDDDDBB A" \
              "A XXX    BBBBD   DBB A" \
              "A FFF DD GGGGD E DBB A" \
              "A FFF DD GGGGD E DBB A" \
              "A BBB    BBBBD   DBB A" \
              "A BBBBBBBBBBBDDDDDBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0],
        [1, 1]])
    end

    it "scans 3 level 15" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBDDDDDBB A" \
              "A XXX    BBBBD   YBB A" \
              "A FFF DD GGGGD E DBB A" \
              "A FFF DD GGGGD E DBB A" \
              "A WBB    BBBBD   DBB A" \
              "A BBBBBBBBBBBDDDDDBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {versus: :o, treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 1],
        [1, 0]])
    end

    it "scans 3 level 16" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBB    BBBBBBBBBBB A" \
              "A BBB DD BBBBBBBBBBB A" \
              "A BBB DD BBBBBBBBBBB A" \
              "A BBB    BBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result.metadata[:groups]).to eq(3)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0]])
    end

    it "scans 3 level 17" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A B                B A" \
              "A B  EE  HH CCCCCC B A" \
              "A B  EE  HH CCCCCC B A" \
              "A B         C    C B A" \
              "A B  FF  GG C DD C B A" \
              "A B  FF  GG C DD C B A" \
              "A B         C    C B A" \
              "A B         CCCCCC B A" \
              "A B                B A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true, compress: {linear: true}}).process_info
      expect(result.points).to match_expected_json
      expect(result.metadata[:groups]).to eq(8)
      expect(result.metadata[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0],
        [1, 0],
        [1, 0],
        [1, 0],
        [1, 0],
        [4, 0]])
    end

    it "scans 3 level 18" do
      chunk =
        "A0000000000000000000" \
        "B0    C0    D0    E0" \
        "F0 G0 H0 I0 J0 K0 L0" \
        "M0 N0 O0 P0 Q0 R0 S0" \
        "T0    U0    V0    X0" \
        "Y0000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 20), @matcher, nil, {treemap: true, compress: {uniq: true, linear: true}}).process_info
      # ABFMTYXSLEA-GNG-IPI-KRK
      expect(result.metadata[:groups]).to eq(4)
      expect(result.points).to match_expected_json
      expect(result.metadata[:treemap]).to eq([
        [-1, -1], # A
        [0, 0],   # G
        [0, 2],   # I
        [0, 1]   # K
      ])

      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 20), @matcher, nil, {versus: :o, treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.points).to match_expected_json(addons: [:o])
      expect(result.metadata[:treemap]).to eq([
        [-1, -1], # A
        [0, 1],   # G
        [0, 2],   # I
        [0, 0]   # K
      ])
    end

    it "scans 3 level 19" do
      chunk = "0000              0000" \
              "0  0 11 000000 33 0  0" \
              "0  0 11 0    0 33 0  0" \
              "0  0    0 22 0    0  0" \
              "0  000000 22 000000  0" \
              "0                    0" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.points).to match_expected_json
      expect(result.metadata[:treemap]).to eq([
        [-1, -1], [-1, -1],
        [-1, -1], [0, 0]
      ])

      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {versus: :o, treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.points).to match_expected_json(addons: [:o])
      expect(result.metadata[:treemap]).to eq([
        [-1, -1], [-1, -1],
        [-1, -1], [0, 0]
      ])
    end

    it "scans 3 level 20" do
      chunk = "0000              0000" \
              "0  0 11 000000    0  0" \
              "0  0 11 0    0 33 0  0" \
              "0  0    0 0000 33 0  0" \
              "0  000000 0       0  0" \
              "0         000000000  0" \
              "0  22222             0" \
              "0  22222             0" \
              "0                    0" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4)
      # 0 1 3 2
      expect(result.metadata[:treemap]).to eq([
        [-1, -1],
        [-1, -1],
        [-1, -1],
        [0, 0]
      ])
    end

    it "scans 3 level 21" do
      chunk = "AAAAAA 11 BBBBBBBB" \
              "C    V 11 R      Q" \
              "D    U    S      P" \
              "E 22 TTTTTT   33 O" \
              "F 22          33 N" \
              "G 22          33 M" \
              "H                L" \
              "IIIIIIIIIIIIIIIIII"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 18), @matcher, nil, {treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4) # 0 1 2 3
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [0, 0], [0, 0]])

      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 18), @matcher, nil, {versus: :o, treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4) # 0 1 2 3
      expect(result.metadata[:treemap]).to eq([[-1, -1], [-1, -1], [0, 0], [0, 0]])
    end

    it "scans 3 level 22" do
      chunk = "AAAAAA    BBBBBBBBBB" \
              "C    V    R        Q" \
              "D    U    S 222222 P" \
              "E 11 T    T 2    2 O" \
              "F 11 TTTTTT 2 33 2 N" \
              "G 11        2 33 2 M" \
              "H           2    2 L" \
              "H           222222 L" \
              "H                  L" \
              "IIIIIIIIIIIIIIIIIIII"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 20), @matcher, nil, {treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4) # 0 2 1 3
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 0], [1, 0]])

      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 20), @matcher, nil, {versus: :o, treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4) # 0 2 1 3
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0], [0, 0], [1, 0]])
    end

    it "scans 3 level 23" do
      chunk = "AAAAAAAAAAAAAAAAAA" \
              "A                A" \
              "A 2              A" \
              "A                A" \
              "AAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 18), @matcher, nil, {treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points.size).to eq(2)
      expect(result.points).to match_expected_json
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 0]])
    end

    it "scans 3 level 24" do
      chunk = "           99999999999" \
              "           5         0" \
              "           0         0" \
              "        66666   11   7" \
              "888888888   0   11   0" \
              "0           0   11   0" \
              "0    22     0   11   0" \
              "0    22     0        0" \
              "0           0        0" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(3)
      expect(result.points).to match_expected_json
      expect(result.metadata[:treemap]).to eq([
        [-1, -1], # 0 (left hole pos 1 right hole pos 0)
        [0, 0],   # 1
        [0, 1]
      ])  # 2
    end

    it "scans 3 level 25" do
      chunk = "             999999999" \
              "             0       0" \
              "        6666666  11  7" \
              "        8     0  11  0" \
              "0000000000 22 0  11  0" \
              "0        0 22 0  11  0" \
              "0  3333  0    0      0" \
              "0  3333  0    0      0" \
              "0        0    0      0" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.points).to match_expected_json
      expect(result.metadata[:treemap]).to eq([
        [-1, -1], # 0 (left hole pos 2 mid pos 1, right hole pos 0)
        [0, 0],   # 1
        [0, 1], # 2
        [0, 2]
      ])  # 3
    end

    it "scans 3 level 26" do
      chunk = "0000000000   999999999" \
              "0        0   0       0" \
              "0  333  6666666  11  7" \
              "0  333  8     0  11  0" \
              "0       0 222 0  11  0" \
              "0       0 222 0  11  0" \
              "0       0     0      0" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(4)
      expect(result.points).to match_expected_json
      expect(result.metadata[:treemap]).to eq([
        [-1, -1], # 0 (left hole pos 0 mid hole pos 2, right hole pos 1)
        [0, 0],   # 3
        [0, 1], # 1
        [0, 2]
      ])  # 2
    end

    it "scans 3 level 27" do
      skip
      chunk = "0000000000000000000000" \
              "0                    0" \
              "0         000000000  0" \
              "0         0       0  0" \
              "0         0       0  0" \
              "00000000000       0  0" \
              "0         0  222  0  0" \
              "0         0       0  0" \
              "0         0       0  0" \
              "0         000000000  0" \
              "0                    0" \
              "0000000000000000000000"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22),
        @matcher, nil, {versus: :a, treemap: true, compress: {uniq: true, linear: true}}).process_info
      expect(result.metadata[:groups]).to eq(2)
      verify_treemap(result)
      expect(result.metadata[:treemap]).to eq([[-1, -1], [0, 1]])
    end
  end
end
