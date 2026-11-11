# frozen_string_literal: true

RSpec.shared_examples "multiclass" do
  describe "multiclass" do
    it "multiclass scans case 1" do
      chunk = "11111     "
      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 10),
        nil,
        nil,
        {multiclass: true, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json
    end

    it "multiclass scans case 2" do
      chunk = "1111111111" \
               "2222   333"
      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 10),
        nil,
        nil,
        {multiclass: true, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json
    end

    it "multiclass scans case 3" do
      chunk = "1111111111" \
              "2222   333" \
              "44444 4444"
      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 10),
        nil,
        nil,
        {multiclass: true, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json
    end

    it "multiclass scans case 4" do
      chunk = "1111122222" \
              "1112222222"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiclass scans case 5" do
      chunk = "1111122222" \
              "1112222222" \
              "1111111222"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiclass scans case 6" do
      chunk = "1111122222" \
              "111    222" \
              "1111112222"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiclass scans case 7" do
      chunk = "1111122222"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiclass scans case 8" do
      chunk = "111111    " \
              "111 11    "
      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 10),
        nil,
        nil,
        {multiclass: true, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json

      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 10),
        nil,
        nil,
        {multiclass: true, versus: :o, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiclass scans case 9" do
      chunk = "1111111111" \
              "111      1"
      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 10),
        nil,
        nil,
        {multiclass: true, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json

      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 10),
        nil,
        nil,
        {multiclass: true, versus: :o, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiclass scans case 10" do
      chunk = "1111122222" \
              "111 1  222"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "multiclass scans case 11" do
      chunk = "1111122222" \
              "111 12 222" \
              "1111122222"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 10),
        matcher: nil,
        options: {multiclass: true, number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiclass scans case 12 treemap" do
      chunk = "1111111111" \
              "1        1" \
              "1   34   1" \
              "1        1" \
              "1111111111"
      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 10),
        nil,
        nil,
        {multiclass: true, treemap: true, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json
      # TODO fix treemap wrong inhole index on multiclass
      # expected: [[-1, -1], [0, 0], [1, 0], [1, 1]]
      #      got: [[-1, -1], [0, 0], [1, -1], [1, -1]]
      # expect(result[:metadata][:treemap]).to eq([[-1, -1], [0, 0], [1, 0], [1, 1]])
    end

    # This case demonstrates the issue with the class 2 pixel at position x=8, y=7.
    # Without the class check, an infinite loop occurs.
    # (EXCLUSIVE) ([8,7][8,8])
    # (SEAM) ([9,8][9,7])

    it "multiclass scans case 13" do
      chunk =
        "       356  2 2  5" \
        "       35  2112  7" \
        "        5 2112 267" \
        "        5521122 67" \
        "       3 52 125676" \
        "        5 22115776" \
        "       3 22 2 6865" \
        "        2   22665 " \
        "       3  22256655" \
        "        5  12666  " \
        "        552156566 " \
        "        552 555762" \
        "         5 2 55752" \
        "        5 1 5555 0" \
        "        52255  620"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: nil,
        options: {connectivity: 8, multiclass: true, number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json store_data: true
    end

    it "multiclass scans case 14" do
      chunk =
        "222            22  2" \
        "2     2       2    2" \
        "2    222    222     " \
        "2    222    222     " \
        "2    2222222222     " \
        "22222 22  2         " \
        "2222    22          " \
        "22222222222222222222"

      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 20),
        nil,
        nil,
        {multiclass: true, connectivity: 8, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json
    end

    it "multiclass scans case 15" do
      chunk =
        "                    " \
        "       22222        " \
        "     22     22      " \
        "       22222        " \
        "     22     22      " \
        "       22222        " \
        "                    "

      result = @simple_polygon_finder.new(@bitmap_class.new(chunk, 20),
        nil,
        nil,
        {multiclass: true, connectivity: 8, versus: :a, compress: {uniq: true, linear: true}}).process_info
      expect(result.points).to match_expected_json
    end
  end
end
