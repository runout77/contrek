# frozen_string_literal: true

RSpec.shared_examples "generic" do
  describe "generic" do
    it "pass bounds option" do
      chunk = "                " \
              "     XXXXXXX    " \
              "     XXXXXXX    " \
              "     XXXXXXX    " \
              "     XXXXXXX    " \
              "     XXXXXXX    " \
              "                "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, bounds: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {bounds: {min_x: 5, max_x: 12, min_y: 1, max_y: 6},
         outer: [{x: 12, y: 1}, {x: 12, y: 6}, {x: 5, y: 6}, {x: 5, y: 1}],
         inner: []}
      ])
    end

    it "works deterministic" do
      workers = 8
      chunk = " XXXX  XXXXXXXXXX  XXXXXXXXX  XXXXXXXXXXX  XXXXXXX" \
              " X  X  X        X  X       X  X         X  X     X" \
              " X  XXXX  XXXX  XXXX  XXX  XXXX  XXXXX  XXXX XXX X" \
              " X        X  X        X X        X   X       X X X" \
              " XXXXXXXXXX  XXXXXXXXXX XXXXXXXXXX   XXXXXXXXX XXX"
      result = @polygon_finder_class.new(
        number_of_threads: workers,
        bitmap: @bitmap_class.new(chunk, 50),
        matcher: @matcher,
        options: {number_of_tiles: workers, versus: :a, deterministic: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "works deterministic but requires even number of tiles" do
      expect {
        @polygon_finder_class.new(
          number_of_threads: 8,
          bitmap: @bitmap_class.new("1234567890", 10),
          matcher: @matcher,
          options: {number_of_tiles: 3, versus: :a, deterministic: true, compress: {uniq: true, linear: true}}
        )
      }.to raise_error(ArgumentError, "Deterministic mode requires an even number of tiles!")
    end
  end
end
