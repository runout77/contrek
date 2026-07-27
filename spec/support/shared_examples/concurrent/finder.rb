# frozen_string_literal: true

# rubocop:disable Layout/ArrayAlignment, Layout/FirstArrayElementIndentation
RSpec.shared_examples "finder" do
  describe "finder" do
    it "number_of_tiles 0 is ignored and forced to 1" do
      chunk = "111" \
              "111" \
              "111"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 3),
        matcher: @matcher,
        options: {number_of_tiles: 0, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "unsupported width" do
      chunk = "1" \
              "1" \
              "0"
      expect {
        @polygon_finder_class.new(
          bitmap: @bitmap_class.new(chunk, 1),
          matcher: @matcher,
          options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
        )
      }.to raise_error(RuntimeError, "One pixel tile width minimum!")
    end

    it "simpler case" do
      chunk = "         " \
              "  11111  " \
              "  11111  " \
              "  11111  " \
              "         "
      opts = {versus: :o, compress: {uniq: true, linear: true}}
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 9),
        @ruby_matcher,
        nil,
        opts
      ).process_info
      expect(result.points).to eq([{outer: [{x: 7, y: 1}, {x: 7, y: 4}, {x: 2, y: 4}, {x: 2, y: 1}], inner: []}])
      expect(result.metadata[:options]).to eq(opts)

      opts = {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: opts
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
      expect(result.metadata[:options]).to eq(opts)
    end

    it "2 workers left border" do
      chunk = "         " \
              "1111111  " \
              "1111111  " \
              "1111111  " \
              "         "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
      expect(result.metadata[:versus]).to eq :o

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
      expect(result.metadata[:versus]).to eq :a
    end

    it "2 workers right border" do
      chunk = "         " \
              "  1111111" \
              "  1111111" \
              "  1111111" \
              "         "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 9, y: 1}, {x: 9, y: 4}, {x: 2, y: 4}, {x: 2, y: 1}],
         inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "2 workers both border" do
      chunk = "         " \
              "111111111" \
              "111111111" \
              "111111111" \
              "         "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 9, y: 1}, {x: 9, y: 4}, {x: 0, y: 4}, {x: 0, y: 1}],
         inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "2 workers case both border divided" do
      chunk = "1111 1111" \
              "1111 1111" \
              "111111111" \
              "111111111" \
              "1111 1111" \
              "1111 1111"
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 9),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 4, y: 0}, {x: 4, y: 2}, {x: 5, y: 2}, {x: 5, y: 0}, {x: 9, y: 0}, {x: 9, y: 6}, {x: 5, y: 6}, {x: 5, y: 4}, {x: 4, y: 4}, {x: 4, y: 6}, {x: 0, y: 6}, {x: 0, y: 0}], inner: []}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers one rectangle" do
      chunk = "                " \
              "    AAAAAAAA    " \
              "    AA    AA    " \
              "    AA    AA    " \
              "    AAAAAAAA    " \
              "                "

      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 12, y: 1}, {x: 12, y: 5}, {x: 4, y: 5}, {x: 4, y: 1}], inner: [[{x: 10, y: 2}, {x: 6, y: 2}, {x: 6, y: 4}, {x: 10, y: 4}, {x: 10, y: 3}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers 2 rectangles" do
      chunk = "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AA    AA    " \
              "    AA    AA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "                " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AA    AA    " \
              "    AA    AA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers one rectangle wider border" do
      chunk = "                " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AA    AA    " \
              "    AA    AA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "                "

      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 12, y: 1}, {x: 12, y: 7}, {x: 4, y: 7}, {x: 4, y: 1}], inner: [[{x: 10, y: 3}, {x: 6, y: 3}, {x: 6, y: 5}, {x: 10, y: 5}, {x: 10, y: 4}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers one rectangle border wider and wider" do
      chunk = "                " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AA    AA    " \
              "    AA    AA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "                "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers one rectangle no holes (clockwise)" do
      chunk = "                " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "                "
      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([
        {outer: [{x: 12, y: 1}, {x: 12, y: 5}, {x: 4, y: 5}, {x: 4, y: 1}],
         inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers one rectangle no holes anticlockwise" do
      chunk = "                " \
              "    AAA         " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "                "
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 4, y: 1}, {x: 4, y: 5}, {x: 12, y: 5}, {x: 12, y: 2}, {x: 7, y: 2}, {x: 7, y: 1}], inner: []}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "2 workers one rectangle no holes (clockwise) attempt two" do
      chunk = "                " \
              "    AAA         " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "    AAAAAAAA    " \
              "                "
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([
        {outer: [{x: 7, y: 1}, {x: 7, y: 2}, {x: 12, y: 2}, {x: 12, y: 5}, {x: 4, y: 5}, {x: 4, y: 1}],
         inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers one rectangle no holes converts to two holes" do
      chunk = "                " \
              "  AAAAAAAAAAAA  " \
              "  AA        AA  " \
              "  AA        AA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AA        AA  " \
              "  AA        AA  " \
              "  AAAAAAAAAAAA  " \
              "                "

      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 14, y: 1}, {x: 14, y: 9}, {x: 2, y: 9}, {x: 2, y: 1}], inner: [[{x: 12, y: 2}, {x: 4, y: 2}, {x: 4, y: 4}, {x: 12, y: 4}, {x: 12, y: 3}], [{x: 12, y: 6}, {x: 4, y: 6}, {x: 4, y: 8}, {x: 12, y: 8}, {x: 12, y: 7}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers one rectangle" do
      chunk = "     XXXXXXX    " \
              "     XX   XX    " \
              "     XX   XX    " \
              "     XX   XX    " \
              "     XXXXXXX    "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      # Contrek::Bitmaps::RawBitmap.gfx_render!(result, zoom: 60, coords: false)
      expect(result.points).to match_expected_json
    end

    it "2 workers one rectangle two holes" do
      chunk = "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AA        AA  " \
              "  AA        AA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AA        AA  " \
              "  AA        AA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  "

      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 14, y: 0}, {x: 14, y: 10}, {x: 2, y: 10}, {x: 2, y: 0}], inner: [[{x: 12, y: 2}, {x: 4, y: 2}, {x: 4, y: 4}, {x: 12, y: 4}, {x: 12, y: 3}], [{x: 12, y: 6}, {x: 4, y: 6}, {x: 4, y: 8}, {x: 12, y: 8}, {x: 12, y: 7}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "2 workers two rectangles" do
      chunk = "                " \
              "AAAAAA   AAAAAA " \
              "AA  AA   AA  AA " \
              "AA  AA   AA  AA " \
              "AAAAAA   AAAAAA " \
              "                "

      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 6, y: 1}, {x: 6, y: 5}, {x: 0, y: 5}, {x: 0, y: 1}], inner: [[{x: 4, y: 2}, {x: 2, y: 2}, {x: 2, y: 4}, {x: 4, y: 4}, {x: 4, y: 3}]]}, {outer: [{x: 15, y: 1}, {x: 15, y: 5}, {x: 9, y: 5}, {x: 9, y: 1}], inner: [[{x: 13, y: 2}, {x: 11, y: 2}, {x: 11, y: 4}, {x: 13, y: 4}, {x: 13, y: 3}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "3 workers one inner on second rectangles" do
      chunk = "                " \
              "AAAAAAAAAAAAAAAA" \
              "AAAAAAAAAAAAAAAA" \
              "AAAAAA   AAAAAAA" \
              "AAAAAAAAAAAAAAAA" \
              "AAAAAAAAAAAAAAAA" \
              "                "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers two rectangles, 3 holes" do
      chunk = "                " \
              "AAAAAAAAAAAAAAAA" \
              "AA  AA    AA  AA" \
              "AA  AA    AA  AA" \
              "AAAAAAAAAAAAAAAA" \
              "                "

      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 16, y: 1}, {x: 16, y: 5}, {x: 0, y: 5}, {x: 0, y: 1}], inner: [[{x: 14, y: 2}, {x: 12, y: 2}, {x: 12, y: 4}, {x: 14, y: 4}, {x: 14, y: 3}], [{x: 2, y: 4}, {x: 4, y: 4}, {x: 4, y: 2}, {x: 2, y: 2}, {x: 2, y: 3}], [{x: 10, y: 2}, {x: 6, y: 2}, {x: 6, y: 4}, {x: 10, y: 4}, {x: 10, y: 3}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "2 workers two rectangles, 3 holes, wider borders" do
      chunk = "                " \
              "AAAAAAAAAAAAAAAA" \
              "AAAAAAAAAAAAAAAA" \
              "AA  AA    AA  AA" \
              "AA  AA    AA  AA" \
              "AAAAAAAAAAAAAAAA" \
              "AAAAAAAAAAAAAAAA" \
              "                "

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "3 workers one opened rectangle" do
      chunk = "AAAAAAAAAAAA" \
              "AAAAAAAAAAAA" \
              "AA          " \
              "AA          " \
              "AAAAAAAAAAAA" \
              "AAAAAAAAAAAA"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 12),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 12),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "3 workers one rectangle" do
      chunk = "                " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AA        AA  " \
              "  AA        AA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "                "
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 14, y: 1}, {x: 14, y: 7}, {x: 2, y: 7}, {x: 2, y: 1}], inner: [[{x: 12, y: 3}, {x: 4, y: 3}, {x: 4, y: 5}, {x: 12, y: 5}, {x: 12, y: 4}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "3 workers one shape letter c like (A)" do
      chunk = "                " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAA        " \
              "  AAAAAA        " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "                "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "3 workers one shape letter c like (B)" do
      chunk = "                " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAA        " \
              "  AAAAAA        " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "                "
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 2, y: 1}, {x: 2, y: 7}, {x: 14, y: 7}, {x: 14, y: 5}, {x: 8, y: 5}, {x: 8, y: 3}, {x: 14, y: 3}, {x: 14, y: 1}], inner: []}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "3 workers one rectangle without inners" do
      chunk = "                " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "                "
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result[:polygons]).to eq([{outer: [{x: 14, y: 1}, {x: 14, y: 6}, {x: 2, y: 6}, {x: 2, y: 1}], inner: []}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "3 workers one rectangle with inners" do
      chunk = "     AAAAAAA    " \
              " AAAAAAAAAAAAAA " \
              " AAAA       AAA " \
              " AAAA       AAA " \
              " AAAA       AAA " \
              " AAAAAAAAAAAAAA " \
              "     AAAAAAA    "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "3 workers one rectangle multiple polylines" do
      chunk = "AAAAA    AAAAAAA" \
              "AAAAA    AAAAAAA" \
              "   AAAAAAAA   AA" \
              "   AAAAAAAA   AA" \
              " AAA      AAAAAA" \
              " AAA      AAAAAA" \
              "   AAAAAAAAA    " \
              "   AAAAAAAAA    "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "circle" do
      chunk = "     AAAAAA     " \
              "    AA    AA    " \
              "   AA      AA   " \
              "  AA        AA  " \
              " AA          AA " \
              "  AA        AA  " \
              "   AA      AA   " \
              "    AA    AA    " \
              "     AAAAAA     "

      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 5, y: 0}, {x: 5, y: 1}, {x: 4, y: 1}, {x: 4, y: 2}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 1, y: 4}, {x: 1, y: 5}, {x: 2, y: 5}, {x: 2, y: 6}, {x: 3, y: 6}, {x: 3, y: 7}, {x: 4, y: 7}, {x: 4, y: 8}, {x: 5, y: 8}, {x: 5, y: 9}, {x: 11, y: 9}, {x: 11, y: 8}, {x: 12, y: 8}, {x: 12, y: 7}, {x: 13, y: 7}, {x: 13, y: 6}, {x: 14, y: 6}, {x: 14, y: 5}, {x: 15, y: 5}, {x: 15, y: 4}, {x: 14, y: 4}, {x: 14, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}, {x: 12, y: 2}, {x: 12, y: 1}, {x: 11, y: 1}, {x: 11, y: 0}], inner: [[{x: 6, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}, {x: 11, y: 2}, {x: 11, y: 3}, {x: 12, y: 3}, {x: 12, y: 4}, {x: 13, y: 4}, {x: 13, y: 5}, {x: 12, y: 5}, {x: 12, y: 6}, {x: 11, y: 6}, {x: 11, y: 7}, {x: 10, y: 7}, {x: 10, y: 8}, {x: 6, y: 8}, {x: 6, y: 7}, {x: 5, y: 7}, {x: 5, y: 6}, {x: 4, y: 6}, {x: 4, y: 5}, {x: 3, y: 5}, {x: 3, y: 4}, {x: 4, y: 4}, {x: 4, y: 3}, {x: 5, y: 3}, {x: 5, y: 2}, {x: 6, y: 2}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "does the work with at least two pixel border" do
      chunk = "      XXXXXXX   " \
              "    XXX    XX   " \
              "    XX     XX   " \
              "    XXX    XX   " \
              "      XXXXXXX   "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "does the work with at least two pixel border right" do
      chunk = "    XXXXXX      " \
              "    X   XX      " \
              "    X   XX      " \
              "    X   XX      " \
              "    XXXXXX      "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "does the work with at least two pixel border (b)" do
      chunk = "      XXXXX     " \
              "    XXX  XX     " \
              "    X    XX     " \
              "    XXX  XX     " \
              "      XXXXX     "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "circle with shape inside" do
      chunk = "     XXXXXX     " \
              "    XX    XX    " \
              "   XX      XX   " \
              "  XX        XX  " \
              " XX   XXXXX  XX " \
              " XX XXX  XX  XX " \
              " XX X    XX  XX " \
              " XX XXX  XX  XX " \
              "  XX  XXXXX XX  " \
              "   XX      XX   " \
              "    XX    XX    " \
              "     XXXXXX     "
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "does the work with many workers" do
      chunk = " XXXXXXX  XXXXXXX   XXXXXXX  XXXXXXX    " \
              " XX   XX  XX   XX   XX   XX  XX   XX    " \
              " XX   XX  XX   XX   XX   XX  XX   XX    " \
              " XX   XX  XX   XX   XX   XX  XX   XX    " \
              " XXXXXXX  XXXXXXX   XXXXXXX  XXXXXXX    "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 6, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: ["6"])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 5, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: ["5"])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: ["4"])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: ["4o"])
    end

    it "search for a missing block" do
      chunk = " XXXX  XXXX  XXXX  XXXX XXXX  XXXX   XXXX  XXXX   " \
              " XXXX  XXXX  X  X  XXXX XXXX  XXXX   X  X  XXXX   " \
              " XXXX  XXXX  X  X  XXXX XXXX  XXXX   X  X  XXXX   " \
              " XXXX  XXXX  X  X  XXXX XXXX  XXXX   X  X  XXXX   " \
              " XXXX  XXXX  XXXX  XXXX XXXX  XXXX   XXXX  XXXX   "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 50),
        matcher: @matcher,
        options: {number_of_tiles: 5, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "circle with inside parts" do
      chunk = "     XXXXXX     " \
              "    XXXXXXXX    " \
              "   XXXXXXXXXX   " \
              "  XXX      XXX  " \
              " XXX        XXX " \
              " XXX        XXX " \
              " XXX        XXX " \
              " XXX        XXX " \
              "  XXX      XXX  " \
              "   XXXXXXXXXX   " \
              "    XXXXXXXX    " \
              "     XXXXXX     "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "rectangle with holes" do
      chunk = "XXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXX" \
              "XXXXX  XXXXXXXXX" \
              "XXXX   XXXXXXXXX" \
              "XXXX    XXXXXXXX" \
              "XXXX    XXXXXXXX" \
              "XXXX   XXXXXXXXX" \
              "XXXXX  XXXXXXXXX" \
              "XXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXX" \
              "XXXXX  XXXXXXXXX" \
              "XXXX   XXXXXXXXX" \
              "XXXX    XXXXXXXX" \
              "XXXX    XXXXXXXX" \
              "XXXX   XXXXXXXXX" \
              "XXXXX  XXXXXXXXX" \
              "XXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "circle with inside" do
      chunk = "    XXXXXXXX    " \
              "   XXXXXXXXXX   " \
              "  XXX  XXXXXXX  " \
              " XXX   XXXXXXXX " \
              " XXX    XXXXXXX " \
              " XXX    XXXXXXX " \
              " XXX   XXXXXXXX " \
              "  XXX  XXXXXXX  " \
              "   XXXXXXXXXX   " \
              "    XXXXXXXX    "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "rectangle with inside hole linear" do
      chunk = " XXXXXXXXXXXXXXX" \
              " XXXXXXXXXXXXXXX" \
              " XXX   XXXXXXXXX" \
              " XXX   XXXXXXXXX" \
              " XXX   XXXXXXXXX" \
              " XXX   XXXXXXXXX" \
              " XXX   XXXXXXXXX" \
              " XXX   XXXXXXXXX" \
              " XXXXXXXXXXXXXXX" \
              " XXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "circle with inside hole" do
      chunk = "    XXXXXXXX    " \
              "   XXXXXXXXXX   " \
              "  XXXXXXX  XXX  " \
              " XXXXXXX   XXXX " \
              " XXXXX     XXXX " \
              " XXXXX     XXXX " \
              " XXXXXXX   XXXX " \
              "  XXXXXXX  XXX  " \
              "   XXXXXXXXXX   " \
              "    XXXXXXXX    "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "problematic shape" do
      chunk = "       XXXXXXX  " \
              "       XXXXXXX  " \
              "       XXXXXXX  " \
              "       XXXXXXX  " \
              "     XXXXXXXXX  " \
              "  XXXXXXXXXXXX  " \
              " XXXXXXXXXXXXXX " \
              " XXXXXXXXXXXXXX " \
              " XXXXXXXXXXXXXX " \
              " XXXXXXXXXXXXXX " \
              "  XXXXXXXXXXXX  " \
              "       XXXXXX   " \
              "                "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "holed circle and many workers" do
      chunk = "    XXXXXXXXX         " \
              "   XXXXXXXXXXX        " \
              "  XXXXXXXXXXXXX       " \
              " XXXXX    XXXXXX      " \
              " XXXX      XXXXX      " \
              " XXXX      XXXXX      " \
              " XXXXX    XXXXXX      " \
              "  XXXXXXXXXXXXX       " \
              "   XXXXXXXXXXX        " \
              "    XXXXXXXXX         "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "circle many holes many workers" do
      chunk = "   XXXXXXXXXXXXXXXX   " \
              "  XXXXXXXXXXXXXXXXXX  " \
              " XXXX  XXXXXXXXXXXXXX " \
              "XXXX    XXXX      XXXX" \
              "XXXXX  XXXXX  XX  XXXX" \
              "XXXXXXXXXXXX  XX  XXXX" \
              "XXXX    XXXX  XX  XXXX" \
              " XXX    XXXX      XXX " \
              "  XX    XXXXXXXXXXXX  " \
              "   XXXXXXXXXXXXXXXX   " \
              "   XXXXXXXXXXXXXXXX   "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "circle with complex hole and many workers" do
      chunk = "   XXXXXXXXXXXXXXXX   " \
              "  XXXXXXXXXXXXXXXXXX  " \
              " XXXXXXXXXXXXXXXXXXXX " \
              "XXXXXXXXXXXX      XXXX" \
              "XXXXXXXXXXXX      XXXX" \
              "XXXX    XXXX      XXXX" \
              "XXXX              XXXX" \
              " XXX              XXX " \
              "  XX    XXXXXXXXXXXX  " \
              "   XXXXXXXXXXXXXXXX   " \
              "   XXXXXXXXXXXXXXXX   "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "problematic case" do
      chunk = "XXXXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXX           X" \
              "XXXXXXXXXX           X" \
              "XXXXXXXXXX           X" \
              "XXXXXXXXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "letter e, problem class a" do
      chunk = "  XXXXXXXXXXXX" \
              " XXXXXXXXXXXXX" \
              " XXX       XXX" \
              "XXXX       XXX" \
              "XXXX       XXX" \
              "XXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXX" \
              "XXXX          " \
              " XXX          " \
              " XXX          " \
              "  XXXXXXXXXXXX" \
              "   XXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 14),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "circle with asymmetrical holes" do
      chunk = "  XXXXXXXXXXXXXXXXXX  " \
              " XXXXXXXXXXXXXXXXXXXX " \
              " XXX       XXXXXXXXXX " \
              "XXXX       XXXXXXXXXXX" \
              "XXXX       XXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXXXX" \
              "XXXX            XXXXXX" \
              " XXX            XXXXX " \
              " XXX            XXXX  " \
              "  XXXXXXXXXXXXXXXXXX  " \
              "   XXXXXXXXXXXXXXXX   "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "holed side overlapping tiles common limits" do
      chunk = "XXXXXXXXXXXX" \
              "XXXXXXXXXXXX" \
              "     XXXXXXX" \
              "      XXXXXX" \
              "      XXXXXX" \
              "     XXXXXXX" \
              "XXXXXXXXXXXX" \
              "XXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 12),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "closed holed side overlapping tiles common limits" do
      chunk = "XXXXXXXXXXXX" \
              "XXXXXXXXXXXX" \
              "XXXXXX     X" \
              "XXXXX      X" \
              "XXXXX      X" \
              "XXXXXX     X" \
              "XXXXXXXXXXXX" \
              "XXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 12),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 12),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "tracks hole expanding on three tiles (two unlinked shapes in the middle one)" do
      #        ----*----*----*-----
      chunk = "XXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXX    XXXXXX" \
              "XXXXXXXXX      XXXXX" \
              "XXXXXXXXX      XXXXX" \
              "XXXXXXXXXX    XXXXXX" \
              "XXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "syllable el (sew technic)" do
      #        --------*--------*---------
      chunk = "0000000000000000000        " \
              " 0000000000  00000         " \
              "  000    00   000          " \
              "  000     0   000          " \
              "  000         000          " \
              "  000     0   000          " \
              "  000    00   000          " \
              "  000000000   000          " \
              "  000000000   000          " \
              "  000000000   000          " \
              "  000    00   000          " \
              "  000     0   000          " \
              "  000         000          " \
              "  000     0   000         0" \
              "  000    00   000        00" \
              " 0000000000  00000000000000" \
              "000000000000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 27),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "syllable el (sew technic) case two" do
      #        --------*---------
      chunk = "XXXXXXXXXXXXXXXXXX" \
              " XXXXXXXXXX  XXXXX" \
              "  XXX    XX   XXX " \
              "  XXX     X   XXX " \
              "  XXX         XXX " \
              "  XXX     X   XXX " \
              "  XXX    XX   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXX    XX   XXX " \
              "  XXX     X   XXX " \
              "  XXX         XXX " \
              "  XXX     X   XXX " \
              "  XXX    XX   XXX " \
              " XXXXXXXXXX  XXXXX" \
              "XXXXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "syllable el (sew technic) case three" do
      chunk = "XXXXXXXXXXXXXXXXXX" \
              " XXXXXXXXXX  XXXXX" \
              "  XXX     X   XXX " \
              "  XXX         XXX " \
              "  XXX     X   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXX     X   XXX " \
              "  XXX     X   XXX " \
              "  XXX     X   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXX     X   XXX " \
              "  XXX         XXX " \
              "  XXX     X   XXX " \
              " XXXXXXXXXX  XXXXX" \
              "XXXXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "syllable el (sew technic) case four" do
      chunk = "XXXXXXXXXXXXXXXXXX" \
              " XXXXXXXXXX  XXXXX" \
              "  XXX     X   XXX " \
              "  XXX         XXX " \
              "  XXX     X   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXX     X   XXX " \
              "  XXX     X   XXX " \
              "  XXX     X   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXX     X   XXX " \
              "  XXX     X   XXX " \
              "  XXX     X   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXXXXXXXX   XXX " \
              "  XXX     X   XXX " \
              "  XXX         XXX " \
              "  XXX     X   XXX " \
              " XXXXXXXXXX  XXXXX" \
              "XXXXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "inscribed rectangles (sew technic)" do
      #        ---------*----------
      chunk = "XXXXXXXXXXXXXXXXXXXX" \
              "X                  X" \
              "X  XXXXXXXXXXXXXX  X" \
              "X  X            X  X" \
              "X  X   XXXX     X  X" \
              "X  XXXXX  X     X  X" \
              "X         X     X  X" \
              "X  XXXXX  X     X  X" \
              "X  X   XXXX     X  X" \
              "X  X            X  X" \
              "X  XXXXXXXXXXXXXX  X" \
              "X                  X" \
              "XXXXXXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "sew technic only" do
      #        ------*-------
      chunk = "XXXXXXXXXXXXXX" \
              "X            X" \
              "X   XXXX     X" \
              "XXXXX  X     X" \
              "       X     X" \
              "XXXXX  X     X" \
              "X   XXXX     X" \
              "X            X" \
              "XXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 14),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "sew technic on holed rectangle" do
      #        ---------*----------
      chunk = "XXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXX" \
              "XXXX            XXXX" \
              "XXXX   XXX      XXXX" \
              "XXXXXXXXXX      XXXX" \
              "XXXXXXXXXX      XXXX" \
              "XXXX   XXX      XXXX" \
              "XXXX            XXXX" \
              "XXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "complex unions in a holed rectanlge and three tiles" do
      chunk = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
              "XXX                        XXX" \
              "XXX    XXXXXXXXXXXX        XXX" \
              "XXX    XXXXXXXXXXXX        XXX" \
              "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
              "XXX                XXXXXXXXXXX" \
              "XXX                XXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 30),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, bounds: true, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "half moon problem 1" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00              0000" \
              "00    00000000000000" \
              "00    00000000000000" \
              "00    00000000000000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 20),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 20, y: 0}, {x: 20, y: 9}, {x: 0, y: 9}, {x: 0, y: 0}], inner: [[{x: 16, y: 2}, {x: 2, y: 2}, {x: 2, y: 7}, {x: 16, y: 7}, {x: 16, y: 6}, {x: 6, y: 6}, {x: 6, y: 3}, {x: 16, y: 3}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "half moon problem 2" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00              0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00  000         0000" \
              "00  00000000    0000" \
              "00  00000000    0000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 20),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 20, y: 0}, {x: 20, y: 14}, {x: 0, y: 14}, {x: 0, y: 0}], inner: [[{x: 16, y: 2}, {x: 2, y: 2}, {x: 2, y: 12}, {x: 16, y: 12}, {x: 16, y: 11}, {x: 4, y: 11}, {x: 4, y: 3}, {x: 16, y: 3}], [{x: 16, y: 5}, {x: 7, y: 5}, {x: 7, y: 6}, {x: 12, y: 6}, {x: 12, y: 8}, {x: 7, y: 8}, {x: 7, y: 9}, {x: 16, y: 9}, {x: 16, y: 6}]]}])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "half moon problem 2 bis" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00              0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00  000         0000" \
              "00  000 000000000000" \
              "00  000 000000000000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 20),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 20, y: 0}, {x: 20, y: 14}, {x: 0, y: 14}, {x: 0, y: 0}], inner: [[{x: 16, y: 2}, {x: 2, y: 2}, {x: 2, y: 12}, {x: 16, y: 12}, {x: 16, y: 11}, {x: 4, y: 11}, {x: 4, y: 3}, {x: 16, y: 3}], [{x: 16, y: 5}, {x: 7, y: 5}, {x: 7, y: 9}, {x: 16, y: 9}, {x: 16, y: 8}, {x: 8, y: 8}, {x: 8, y: 6}, {x: 16, y: 6}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "half moon problem 3" do
      #        ---------*----------
      chunk = "000000000000000000000000" \
              "000000000000000000000000" \
              "00              00000000" \
              "00  00000000000000000000" \
              "00  00000000000000000000" \
              "00  00          00000000" \
              "00  00  0000000000000000" \
              "00  00  0000000000000000" \
              "00  00  00      00000000" \
              "00  00  00      00000000" \
              "00  00  00  000000000000" \
              "00  00  00  000000000000" \
              "00  00  00      00000000" \
              "00  00  00      00000000" \
              "00  00  0000000000000000" \
              "00  00  0000000000000000" \
              "00  00          00000000" \
              "00  00000000000000000000" \
              "00  00000000000000000000" \
              "00              00000000" \
              "000000000000000000000000" \
              "000000000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 24),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "missing shape still missing" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00              0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00  000         0000" \
              "00  000     00  0000" \
              "00  0000000000  0000" \
              "00  0000000000  0000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "missing shape still missing case 2" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00              0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00  000         0000" \
              "00  000 000000  0000" \
              "00  000 000000  0000" \
              "00  000     00  0000" \
              "00  000     00  0000" \
              "00  0000000000  0000" \
              "00  0000000000  0000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "half moon problem 1 (flipped)" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "0000              00" \
              "0000000000000000  00" \
              "0000000000000000  00" \
              "0000         000  00" \
              "000000000000 000  00" \
              "000000000000 000  00" \
              "0000         000  00" \
              "0000000000000000  00" \
              "0000000000000000  00" \
              "0000              00" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiconnections" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00              0000" \
              "00  00000000   00000" \
              "00  00000000   00000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiconnections case 2" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00              0000" \
              "00  00000000    0000" \
              "00  00000000    0000" \
              "00  000   00    0000" \
              "00  000   00    0000" \
              "00  000   00    0000" \
              "00  000   00    0000" \
              "00  00000000    0000" \
              "00  00000000    0000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiconnections case 3" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00              0000" \
              "00  00000000    0000" \
              "00  00000000    0000" \
              "00  000   0000000000" \
              "00  000   0000000000" \
              "00  000   00    0000" \
              "00  000   00    0000" \
              "00  00000000    0000" \
              "00  00000000    0000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiconnections case 4" do
      #        ---------*----------
      chunk = "       0000000000000" \
              "00000000000000000000" \
              "0000000  0000   0000" \
              "0000000  0000   0000" \
              "00              0000" \
              "00  000   0000000000" \
              "00  000   0000000000" \
              "00  000   00    0000" \
              "00  000   00    0000" \
              "00  00000000    0000" \
              "00  00000000    0000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiconnections case 5" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00                00" \
              "00  000000        00" \
              "00  000000  00000000" \
              "00  000    000000000" \
              "00  0000000000    00" \
              "00  0000000000    00" \
              "00  000     00    00" \
              "00  000     00    00" \
              "00  0000000000    00" \
              "00  0000000000    00" \
              "00  000     00    00" \
              "00  000     00    00" \
              "00  0000000000    00" \
              "00  0000000000    00" \
              "00  000     00    00" \
              "00  000     00    00" \
              "00  0000000000    00" \
              "00  0000000000    00" \
              "00  000     00    00" \
              "00  000     00    00" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00          00   000" \
              "00          00   000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiconnections case 6" do
      #        ---------*----------
      chunk = "       0000000000000" \
              "00000000000000000000" \
              "0000000  0000   0000" \
              "0000000  0000   0000" \
              "00                00" \
              "00  000000        00" \
              "00  000000  00000000" \
              "00  000    000000000" \
              "00  0000000000    00" \
              "00  0000000000    00" \
              "00  000     00    00" \
              "00  000     00    00" \
              "00  0000000000    00" \
              "00  0000000000    00" \
              "00  000     00    00" \
              "00  000     00    00" \
              "00  0000000000    00" \
              "00  0000000000    00" \
              "00  000     00    00" \
              "00  000     00    00" \
              "00  0000000000    00" \
              "00  0000000000    00" \
              "00  000     00    00" \
              "00  000     00    00" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00          00   000" \
              "00          00   000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "multiconnections case 7" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00              0000" \
              "00  00000000    0000" \
              "00  00000000    0000" \
              "00  000   00    0000" \
              "00  000   00    0000" \
              "00  000   00    0000" \
              "00  00000000    0000" \
              "00  00000000    0000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00  000         0000" \
              "00  000         0000" \
              "00  0000000     0000" \
              "00  0000000     0000" \
              "00  000         0000" \
              "00  000         0000" \
              "00  0000000000000000" \
              "00  0000000000000000" \
              "00              0000" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end

    it "complex shape" do
      chunk =
        #-----------*-------------
        "          0E0            " \
        "          000            " \
        "          0E00           " \
        "         00 F00          " \
        "         0X  FF00        " \
        "        00     00000     " \
        "        0X     F00000    " \
        "       00       0 0000   " \
        "       0X      F0    0000" \
        "      00      F0      000" \
        "      0X      00     0000" \
        "     00      F0      0000" \
        "     00      00     00   " \
        "     0X     F0      00   " \
        "    00      00     00    " \
        "    00      00     00    " \
        "    0X     G0      00    " \
        "    0      00      0     " \
        "    0      00     00     " \
        "    0      0      00     " \
        "  000     X0      0      " \
        "  00X     00      0      " \
        "  00      0G     00      " \
        "  00      0      00      " \
        "  00      0      00      " \
        "  00      0      00      " \
        "  00     X0      00      " \
        "  00     00      0       " \
        "  00     00      0       " \
        "  00     00      0       " \
        "  00XXXXX00C000000       " \
        "  00  0  00     00       " \
        "  00     00      0       " \
        "  00      0      00      " \
        "  00      0      00      " \
        "  00      00     00      " \
        "  00      00     00      " \
        "  00      00     00      " \
        "  00      00      00     " \
        "  000     00      00     " \
        "  000      0      00     " \
        "    0      00      00    " \
        "    0      00       0    " \
        "    00      0       00   " \
        "    00      00      00   " \
        "     0      00       00  " \
        "     00      00       0  " \
        "     00      00       00 " \
        "      0       00       0 " \
        "      00      00       00" \
        "      00       00       0" \
        "       00      00       0" \
        "       00       00      0" \
        "        00       00     0" \
        "         0       000    0" \
        "         00       000 000" \
        "          00        00000" \
        "          00        00000" \
        "           00      000   " \
        "            00     00    " \
        "            000   00     " \
        "             00  00      " \
        "              00000      " \
        "               000       " \
        "                00       "
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 25),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "complex shape 1" do
      #        ---------*----------
      chunk = "00000000000000      " \
              "000000000000000     " \
              "00  00        00    " \
              "00   00        00   " \
              "00    000000    00  " \
              "00    000000     00 " \
              "00        00      00" \
              "00        00      00" \
              "00000000010000000000" \
              "00        00      00" \
              "00        00     00 " \
              "00    000000    00  " \
              "00    0000     00   " \
              "00    0000    00    " \
              "00   00      00     " \
              "00  00      00      " \
              "00 00      00       " \
              "0000      00        " \
              "000      00         " \
              "00      00          " \
              "000000000           " \
              "000000000           "

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "complex shape 2" do
      chunk = "00000000000000      " \
              "000000000000000     " \
              "00  00        00    " \
              "00   00        00   " \
              "00    000000    00  " \
              "00         00    00 " \
              "00          00    00" \
              "00000000000000000000" \
              "00000000010000000000" \
              "00          00    00" \
              "00         00    00 " \
              "00       000    00  " \
              "00     000     00   " \
              "00    00      00    " \
              "000000000000000     " \
              "00000000000000      "

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to match_expected_json
    end
  end
end
# rubocop:enable Layout/ArrayAlignment, Layout/FirstArrayElementIndentation
