RSpec.shared_examples "treemap" do
  describe "simple cases" do
    it "scans 3 level" do
      chunk = "AAAAAAAAAAAAAAA       " \
              "B             C       " \
              "D EEEEEEEEEEE F       " \
              "G H         I L       " \
              "M N OOOOOOO P Q       " \
              "R S         T U       " \
              "V XXXXXXXXXXX Y       " \
              "W             Z       " \
              "111111111111111       "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(3)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0]])
    end
    it "scans 3 level" do
      chunk = "AAAAAAAAAAAAAAA       " \
              "B             C       " \
              "D EEEEEEEEEEE F       " \
              "G H         I L       " \
              "M N OO 22 3 P Q       " \
              "R S         T U       " \
              "V XXXXXXXXXXX Y       " \
              "W             Z       " \
              "111111111111111       "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(5)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0],
        [1, 0],
        [1, 0]])
    end
    it "scans 3 level plus" do
      chunk = "AAAAAAAAA             " \
              "B       C    22       " \
              "D EEEEE F             " \
              "G H   I L             " \
              "M N O P Q             " \
              "R S   T U             " \
              "V XXXXX Y             " \
              "W       Z             " \
              "111111111             "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(4)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [0, 0],
        [2, 0]])
    end
    it "scans 3 level plus 2" do
      chunk = "AAAAAAAAA             " \
              "B       C    22       " \
              "D EEEEE F             " \
              "G H   I L    3333333  " \
              "M N O P Q    3     3  " \
              "R S   T U    3 44  3  " \
              "V XXXXX Y    3     3  " \
              "W       Z    3333333  " \
              "111111111             "
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
      chunk = "AAAAAAAAA             " \
              "B       C    22       " \
              "D EEEEE F             " \
              "G H   I L    3333333  " \
              "M N O P Q    3     3  " \
              "R S   T U    3 44  3  " \
              "V XXXXX Y    3     3  " \
              "W       Z    3333333  " \
              "111111111             "
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
              "BBBBBB         BBBBBBB" \
              "CCCCCC    GGG  EEEEEEE" \
              "DDDDDD         FFFFFFF"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(2)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1]])
    end

    it "scans 3 level plus 5" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X                    A" \
              "A    AAAAAAAAAAA     A" \
              "A    A         A     A" \
              "Y    C  BBBBB  D     A" \
              "A    A         A     A" \
              "AAAAAA         AAAAAAA" \
              "                      "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(2)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1]])
    end

    it "scans 3 level plus 6" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X                    A" \
              "A    AAAAAAAAAAA     A" \
              "A    A         A     A" \
              "Y    C  BBBBB  D     A" \
              "A    A         A     A" \
              "AAAAAA         AAAAAAA" \
              "                      "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {versus: :o, treemap: true}).process_info
      expect(result[:groups]).to eq(2)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1]])
    end
    it "scans 3 level plus 7" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X                    A" \
              "A    AAAAAAAAAAA     A" \
              "A    A         A     A" \
              "Y    C  BB NN  D     A" \
              "A    A         A     A" \
              "AAAAAA         AAAAAAA" \
              "                      "
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(3)
      expect(result[:treemap]).to eq([[-1, -1],
        [-1, -1],
        [-1, -1]])
    end
    it "scans 3 level plus 8" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "X                    A" \
              "A    AAAAAAAAAAA     A" \
              "A    A         A     A" \
              "Y ZZ C  BB NN  D  11 A" \
              "A    A         A     A" \
              "AAAAAA         AAAAAAA" \
              "                      "
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
              "X                    A" \
              "A    AAAAAAAAAAAAAAAAA" \
              "A    A                " \
              "Y ZZ C  BB NN  DDDDDDD" \
              "A    A         A     A" \
              "AAAAAA         A 11  A" \
              "               A     A" \
              "               AAAAAAA"
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
              "B                    P" \
              "C    QQQQQQQQQQQ     O" \
              "D    R         X     N" \
              "E    S  YYYYY  W     M" \
              "F    T         V     L" \
              "G    UUUUUUUUUUU     K" \
              "H                    J" \
              "IIIIIIIIIIIIIIIIIIIIII"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(3)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0]])
    end
    it "scans 3 level plus 11" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A B                B A" \
              "A B CCCCCC  EE  FF B A" \
              "A B C    C         B A" \
              "A B C DD C GG  HH  B A" \
              "A B C    C         B A" \
              "A B CCCCCC         B A" \
              "A B                B A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
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
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBDDDDDBB A" \
              "A XXX    BBBBD   DBB A" \
              "A FFF DD GGGGD E DBB A" \
              "A BBB    BBBBD   DBB A" \
              "A BBBBBBBBBBBDDDDDBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
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
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBDDDDDBB A" \
              "A XXX    BBBBD   YBB A" \
              "A FFF DD GGGGD E DBB A" \
              "A WBB    BBBBD   DBB A" \
              "A BBBBBBBBBBBDDDDDBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
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
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBB    BBBBBBBBBBB A" \
              "A BBB DD BBBBBBBBBBB A" \
              "A BBB    BBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
              "AAAAAAAAAAAAAAAAAAAAAA"
      result = @polygon_finder_class.new(@bitmap_class.new(chunk, 22), @matcher, nil, {treemap: true}).process_info
      expect(result[:groups]).to eq(3)
      expect(result[:treemap]).to eq([[-1, -1],
        [0, 0],
        [1, 0]])
    end
    it "scans 3 level plus 15" do
      chunk = "AAAAAAAAAAAAAAAAAAAAAA" \
              "A                    A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A B                B A" \
              "A B  EE  HH CCCCCC B A" \
              "A B         C    C B A" \
              "A B  FF  GG C DD C B A" \
              "A B         C    C B A" \
              "A B         CCCCCC B A" \
              "A B                B A" \
              "A BBBBBBBBBBBBBBBBBB A" \
              "A                    A" \
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
