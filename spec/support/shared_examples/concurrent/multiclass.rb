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
  end
end
