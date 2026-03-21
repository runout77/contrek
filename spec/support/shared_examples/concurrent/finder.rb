# rubocop:disable Layout/ArrayAlignment, Layout/FirstArrayElementIndentation
RSpec.shared_examples "finder" do
  describe "various simple cases" do
    it "number_of_tiles 0 is ignored and forced to 1" do
      chunk = "111" \
              "111" \
              "111"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 3),
        matcher: @matcher,
        options: {number_of_tiles: 0, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 2, y: 0}, {x: 2, y: 2}, {x: 0, y: 2}, {x: 0, y: 0}],
                                    inner: []}])
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
      result = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 9),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 6, y: 1}, {x: 6, y: 3}, {x: 2, y: 3}, {x: 2, y: 1}],
         inner: []}
      ])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {inner: [],
         outer: [{x: 3, y: 1}, {x: 6, y: 1}, {x: 6, y: 3}, {x: 3, y: 3}, {x: 2, y: 3}, {x: 2, y: 1}]}
      ])
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
      expect(result.points).to eq([
        {inner: [],
         outer: [{x: 3, y: 1}, {x: 6, y: 1}, {x: 6, y: 3}, {x: 0, y: 3}, {x: 0, y: 1}]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 0, y: 1}, {x: 0, y: 3}, {x: 6, y: 3}, {x: 6, y: 1}, {x: 3, y: 1}], inner: []}
      ])
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
        {outer: [{x: 3, y: 1}, {x: 8, y: 1}, {x: 8, y: 3}, {x: 3, y: 3}, {x: 2, y: 3}, {x: 2, y: 1}],
         inner: []}
      ])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 2, y: 1}, {x: 2, y: 3}, {x: 3, y: 3}, {x: 8, y: 3}, {x: 8, y: 1}, {x: 3, y: 1}],
         inner: []}
      ])
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
        {outer: [{x: 3, y: 1}, {x: 8, y: 1}, {x: 8, y: 3}, {x: 3, y: 3}, {x: 0, y: 3}, {x: 0, y: 1}],
         inner: []}
      ])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 0, y: 1}, {x: 0, y: 3}, {x: 3, y: 3}, {x: 8, y: 3}, {x: 8, y: 1}, {x: 3, y: 1}],
         inner: []}
      ])
    end

    it "2 workers case both border divided" do
      chunk = "1111 1111" \
              "1111 1111" \
              "111111111" \
              "111111111" \
              "1111 1111" \
              "1111 1111"
      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 9),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([
        {outer: [{x: 3, y: 0}, {x: 3, y: 1}, {x: 5, y: 1}, {x: 5, y: 0}, {x: 8, y: 0}, {x: 8, y: 5}, {x: 5, y: 5}, {x: 5, y: 4}, {x: 3, y: 4}, {x: 3, y: 5}, {x: 0, y: 5}, {x: 0, y: 0}], inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 5}, {x: 3, y: 5}, {x: 3, y: 4}, {x: 5, y: 4}, {x: 5, y: 5},
          {x: 8, y: 5}, {x: 8, y: 0}, {x: 5, y: 0}, {x: 5, y: 1}, {x: 3, y: 1}, {x: 3, y: 0}],
         inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 9),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [
           {x: 3, y: 0}, {x: 3, y: 1}, {x: 5, y: 1}, {x: 5, y: 0}, {x: 8, y: 0}, {x: 8, y: 5},
          {x: 5, y: 5}, {x: 5, y: 4}, {x: 3, y: 4}, {x: 3, y: 5}, {x: 0, y: 5}, {x: 0, y: 0}
         ],
         inner: []}
      ])
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
      expect(result.points).to eq([
        {outer: [{x: 11, y: 1}, {x: 11, y: 4}, {x: 4, y: 4}, {x: 4, y: 1}],
         inner: [[{x: 10, y: 2}, {x: 5, y: 2}, {x: 5, y: 3}, {x: 10, y: 3}]]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 7, y: 1}, {x: 11, y: 1}, {x: 11, y: 4}, {x: 7, y: 4}, {x: 4, y: 4}, {x: 4, y: 1}],
         inner: [[{x: 5, y: 2}, {x: 5, y: 3}, {x: 10, y: 3}, {x: 10, y: 2}]]}
      ])
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
      expect(result.points).to eq([
        {outer: [{x: 7, y: 0}, {x: 11, y: 0}, {x: 11, y: 5}, {x: 7, y: 5}, {x: 4, y: 5}, {x: 4, y: 0}],
         inner: [
           [{x: 5, y: 2}, {x: 5, y: 3}, {x: 10, y: 3}, {x: 10, y: 2}]
         ]},
        {outer: [{x: 7, y: 7}, {x: 11, y: 7}, {x: 11, y: 12}, {x: 7, y: 12}, {x: 4, y: 12}, {x: 4, y: 7}],
         inner: [[{x: 5, y: 9}, {x: 5, y: 10}, {x: 10, y: 10}, {x: 10, y: 9}]]}
      ])
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

      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([
        {outer: [{x: 11, y: 1}, {x: 11, y: 6}, {x: 4, y: 6}, {x: 4, y: 1}],
         inner: [[{x: 10, y: 3}, {x: 5, y: 3}, {x: 5, y: 4}, {x: 10, y: 4}]]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 7, y: 1}, {x: 11, y: 1}, {x: 11, y: 6}, {x: 7, y: 6}, {x: 4, y: 6}, {x: 4, y: 1}],
         inner: [[{x: 5, y: 3}, {x: 5, y: 4}, {x: 10, y: 4}, {x: 10, y: 3}]]}
      ])
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
      expect(result.points).to eq([
        {outer: [{x: 7, y: 1}, {x: 11, y: 1}, {x: 11, y: 8}, {x: 7, y: 8}, {x: 4, y: 8},
          {x: 4, y: 1}],
         inner: [[{x: 5, y: 4}, {x: 5, y: 5}, {x: 10, y: 5}, {x: 10, y: 4}]]}
      ])
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
        {outer: [{x: 11, y: 1}, {x: 11, y: 4}, {x: 4, y: 4}, {x: 4, y: 1}],
         inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 7, y: 1}, {x: 11, y: 1}, {x: 11, y: 4}, {x: 7, y: 4}, {x: 4, y: 4}, {x: 4, y: 1}],
         inner: []}
      ])
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
      expect(result.points).to eq([
        {outer: [{x: 4, y: 1}, {x: 4, y: 4}, {x: 11, y: 4}, {x: 11, y: 2}, {x: 6, y: 1}],
         inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 4, y: 1}, {x: 4, y: 4}, {x: 7, y: 4}, {x: 11, y: 4}, {x: 11, y: 2},
          {x: 7, y: 2}, {x: 6, y: 1}], inner: []}
      ])
    end

    it "2 workers one rectangle no holes (clockwise) attempt two" do
      chunk = "                " \
              "    AAA         " \
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
        {outer: [{x: 6, y: 1}, {x: 11, y: 2}, {x: 11, y: 4}, {x: 4, y: 4}, {x: 4, y: 1}],
         inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true}}
      ).process_info
      expect(result.points).to eq([
        {inner: [],
         outer: [{x: 6, y: 1}, {x: 7, y: 2}, {x: 11, y: 2}, {x: 11, y: 3}, {x: 11, y: 4}, {x: 7, y: 4}, {x: 4, y: 4}, {x: 4, y: 3}, {x: 4, y: 2}, {x: 4, y: 1}]}
      ])
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

      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([
        {outer: [{x: 13, y: 1}, {x: 13, y: 8}, {x: 2, y: 8}, {x: 2, y: 1}],
         inner: [
           [{x: 12, y: 2}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 12, y: 3}],
           [{x: 12, y: 6}, {x: 3, y: 6}, {x: 3, y: 7}, {x: 12, y: 7}]
         ]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 7, y: 1}, {x: 13, y: 1}, {x: 13, y: 8}, {x: 7, y: 8}, {x: 2, y: 8}, {x: 2, y: 1}],
         inner: [
           [{x: 3, y: 2}, {x: 3, y: 3}, {x: 12, y: 3}, {x: 12, y: 2}],
           [{x: 3, y: 6}, {x: 3, y: 7}, {x: 12, y: 7}, {x: 12, y: 6}]
         ]}
      ])
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
      expect(result.points).to eq([{outer: [{x: 5, y: 0}, {x: 5, y: 4}, {x: 7, y: 4}, {x: 11, y: 4}, {x: 11, y: 0}, {x: 7, y: 0}], inner: [[{x: 6, y: 3}, {x: 6, y: 1}, {x: 10, y: 1}, {x: 10, y: 3}]]}])
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

      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([
        {outer: [{x: 13, y: 0}, {x: 13, y: 9}, {x: 2, y: 9}, {x: 2, y: 0}],
         inner: [[{x: 12, y: 2}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 12, y: 3}],
           [{x: 12, y: 6}, {x: 3, y: 6}, {x: 3, y: 7}, {x: 12, y: 7}]]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 7, y: 0}, {x: 13, y: 0}, {x: 13, y: 9}, {x: 7, y: 9}, {x: 2, y: 9}, {x: 2, y: 0}],
         inner: [
           [{x: 3, y: 2}, {x: 3, y: 3}, {x: 12, y: 3}, {x: 12, y: 2}],
           [{x: 3, y: 6}, {x: 3, y: 7}, {x: 12, y: 7}, {x: 12, y: 6}]
         ]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 2, y: 0}, {x: 2, y: 9}, {x: 7, y: 9}, {x: 13, y: 9}, {x: 13, y: 0}, {x: 7, y: 0}], inner: [[{x: 3, y: 7}, {x: 3, y: 6}, {x: 12, y: 6}, {x: 12, y: 7}], [{x: 3, y: 3}, {x: 3, y: 2}, {x: 12, y: 2}, {x: 12, y: 3}]]}])
    end

    it "2 workers two rectangles" do
      chunk = "                " \
              "AAAAAA   AAAAAA " \
              "AA  AA   AA  AA " \
              "AA  AA   AA  AA " \
              "AAAAAA   AAAAAA " \
              "                "

      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([
        {outer: [{x: 5, y: 1}, {x: 5, y: 4}, {x: 0, y: 4}, {x: 0, y: 1}],
         inner: [[{x: 4, y: 2}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 4, y: 3}]]},
        {outer: [{x: 14, y: 1}, {x: 14, y: 4}, {x: 9, y: 4}, {x: 9, y: 1}],
         inner: [[{x: 13, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 13, y: 3}]]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 5, y: 1}, {x: 5, y: 4}, {x: 0, y: 4}, {x: 0, y: 1}], inner: [[{x: 4, y: 2}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 4, y: 3}]]}, {outer: [{x: 14, y: 1}, {x: 14, y: 4}, {x: 9, y: 4}, {x: 9, y: 1}], inner: [[{x: 13, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 13, y: 3}]]}])
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
      expect(result.points).to eq([
        {outer: [{x: 4, y: 1}, {x: 9, y: 1}, {x: 15, y: 1}, {x: 15, y: 5}, {x: 9, y: 5}, {x: 4, y: 5}, {x: 0, y: 5}, {x: 0, y: 1}],
         inner: [[{x: 9, y: 3}, {x: 5, y: 3}]]}
      ])
    end

    it "2 workers two rectangles, 3 holes" do
      chunk = "                " \
              "AAAAAAAAAAAAAAAA" \
              "AA  AA    AA  AA" \
              "AA  AA    AA  AA" \
              "AAAAAAAAAAAAAAAA" \
              "                "

      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([
        {outer: [{x: 15, y: 1}, {x: 15, y: 4}, {x: 0, y: 4}, {x: 0, y: 1}],
         inner: [
           [{x: 14, y: 2}, {x: 11, y: 2}, {x: 11, y: 3}, {x: 14, y: 3}],
           [{x: 1, y: 3}, {x: 4, y: 3}, {x: 4, y: 2}, {x: 1, y: 2}],
           [{x: 10, y: 2}, {x: 5, y: 2}, {x: 5, y: 3}, {x: 10, y: 3}]
         ]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {inner: [
           [{x: 4, y: 2}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 4, y: 3}],
          [{x: 5, y: 2}, {x: 5, y: 3}, {x: 10, y: 3}, {x: 10, y: 2}],
          [{x: 14, y: 2}, {x: 11, y: 2}, {x: 11, y: 3}, {x: 14, y: 3}]
         ],
         outer: [{x: 7, y: 1}, {x: 15, y: 1}, {x: 15, y: 4}, {x: 7, y: 4}, {x: 0, y: 4}, {x: 0, y: 1}]}
      ])
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
      expect(result.points).to eq([
        {outer: [{x: 7, y: 1}, {x: 15, y: 1}, {x: 15, y: 6}, {x: 7, y: 6}, {x: 0, y: 6}, {x: 0, y: 1}],
         inner: [[{x: 4, y: 3}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 4, y: 4}],
           [{x: 5, y: 3}, {x: 5, y: 4}, {x: 10, y: 4}, {x: 10, y: 3}],
           [{x: 14, y: 3}, {x: 11, y: 3}, {x: 11, y: 4}, {x: 14, y: 4}]]}
      ])
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
      expect(result.points).to eq([{outer: [{x: 5, y: 0}, {x: 11, y: 0}, {x: 11, y: 1}, {x: 5, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 5, y: 4}, {x: 11, y: 4}, {x: 11, y: 5}, {x: 5, y: 5}, {x: 0, y: 5}, {x: 0, y: 0}], inner: []}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 12),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 5}, {x: 5, y: 5}, {x: 11, y: 5}, {x: 11, y: 4}, {x: 5, y: 4}, {x: 1, y: 3}, {x: 1, y: 2}, {x: 5, y: 1}, {x: 11, y: 1}, {x: 11, y: 0}, {x: 5, y: 0}], inner: []}])
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
      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([
        {outer: [{x: 13, y: 1}, {x: 13, y: 6}, {x: 2, y: 6}, {x: 2, y: 1}],
         inner: [[{x: 12, y: 3}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 12, y: 4}]]}
      ])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{
        outer: [{x: 4, y: 1}, {x: 9, y: 1}, {x: 13, y: 1}, {x: 13, y: 6}, {x: 9, y: 6}, {x: 4, y: 6}, {x: 2, y: 6}, {x: 2, y: 1}], inner: [[{x: 4, y: 2}, {x: 3, y: 3}, {x: 3, y: 4}, {x: 4, y: 5}, {x: 12, y: 4}, {x: 12, y: 3}]]
      }])
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
      expect(result.points).to eq([
        {inner: [],
         outer: [{x: 4, y: 1}, {x: 9, y: 1}, {x: 13, y: 1}, {x: 13, y: 2}, {x: 9, y: 2},
           {x: 7, y: 3}, {x: 7, y: 4}, {x: 9, y: 5}, {x: 13, y: 5}, {x: 13, y: 6},
           {x: 9, y: 6}, {x: 4, y: 6}, {x: 2, y: 6}, {x: 2, y: 1}]}
      ])
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
      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([
        {outer: [{x: 2, y: 1}, {x: 2, y: 6}, {x: 13, y: 6}, {x: 13, y: 5}, {x: 7, y: 4},
          {x: 7, y: 3}, {x: 13, y: 2}, {x: 13, y: 1}], inner: []}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 2, y: 1}, {x: 2, y: 6}, {x: 4, y: 6}, {x: 9, y: 6}, {x: 13, y: 6}, {x: 13, y: 5},
          {x: 9, y: 5}, {x: 7, y: 4}, {x: 7, y: 3}, {x: 9, y: 2}, {x: 13, y: 2}, {x: 13, y: 1},
          {x: 9, y: 1}, {x: 4, y: 1}], inner: []}
      ])
    end

    it "3 workers one rectangle without inners" do
      chunk = "                " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "  AAAAAAAAAAAA  " \
              "                "
      result_mono = Contrek::Finder::PolygonFinder.new(
        @ruby_bitmap_class.new(chunk, 16),
        @ruby_matcher,
        nil,
        {versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result_mono[:polygons]).to eq([{
        outer: [{x: 13, y: 1}, {x: 13, y: 5}, {x: 2, y: 5}, {x: 2, y: 1}],
        inner: []
      }])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {inner: [],
         outer: [{x: 4, y: 1}, {x: 9, y: 1}, {x: 13, y: 1}, {x: 13, y: 5},
           {x: 9, y: 5}, {x: 4, y: 5}, {x: 2, y: 5}, {x: 2, y: 1}]}
      ])
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
      expect(result.points).to eq([
        {outer: [{x: 7, y: 0}, {x: 11, y: 0}, {x: 14, y: 1}, {x: 14, y: 5}, {x: 11, y: 6}, {x: 7, y: 6},
          {x: 5, y: 6}, {x: 1, y: 5}, {x: 1, y: 1}, {x: 5, y: 0}],
         inner: [[{x: 4, y: 2}, {x: 4, y: 4}, {x: 12, y: 4}, {x: 12, y: 2}]]}
      ])
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
      expect(result.points).to eq([
        {outer: [{x: 4, y: 0}, {x: 4, y: 1}, {x: 7, y: 2}, {x: 9, y: 1}, {x: 9, y: 0},
          {x: 15, y: 0}, {x: 15, y: 5}, {x: 11, y: 6}, {x: 11, y: 7}, {x: 3, y: 7},
          {x: 3, y: 6}, {x: 1, y: 5}, {x: 1, y: 4}, {x: 3, y: 3}, {x: 3, y: 2},
          {x: 0, y: 1}, {x: 0, y: 0}],
         inner: [[{x: 3, y: 4}, {x: 3, y: 5}, {x: 10, y: 5}, {x: 10, y: 4}],
           [{x: 14, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 14, y: 3}]]}
      ])
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
      expect(result.points).to eq([{outer: [{x: 5, y: 0}, {x: 1, y: 4}, {x: 5, y: 8}, {x: 10, y: 8}, {x: 14, y: 4}, {x: 10, y: 0}], inner: [[{x: 5, y: 1}, {x: 10, y: 1}, {x: 13, y: 4}, {x: 10, y: 7}, {x: 5, y: 7}, {x: 2, y: 4}, {x: 4, y: 2}]]}])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 7, y: 0}, {x: 10, y: 0}, {x: 14, y: 4}, {x: 10, y: 8}, {x: 7, y: 8}, {x: 5, y: 8},
          {x: 1, y: 4}, {x: 5, y: 0}], inner: [
            [{x: 5, y: 1}, {x: 2, y: 4}, {x: 5, y: 7}, {x: 10, y: 7}, {x: 13, y: 4}, {x: 10, y: 1}]
          ]}
      ])
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
      expect(result.points).to eq([{outer: [{x: 6, y: 0}, {x: 4, y: 1}, {x: 4, y: 3}, {x: 6, y: 4}, {x: 7, y: 4}, {x: 12, y: 4}, {x: 12, y: 0}, {x: 7, y: 0}], inner: [[{x: 6, y: 3}, {x: 5, y: 2}, {x: 6, y: 1}, {x: 11, y: 1}, {x: 11, y: 3}]]}])
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
      expect(result.points).to eq([{outer: [{x: 6, y: 0}, {x: 4, y: 1}, {x: 4, y: 3}, {x: 6, y: 4}, {x: 7, y: 4}, {x: 10, y: 4}, {x: 10, y: 0}, {x: 7, y: 0}], inner: [[{x: 6, y: 3}, {x: 4, y: 2}, {x: 6, y: 1}, {x: 9, y: 1}, {x: 9, y: 3}]]}])
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
      expect(result.points).to eq([{outer: [{x: 5, y: 0}, {x: 1, y: 4}, {x: 1, y: 7}, {x: 5, y: 11}, {x: 10, y: 11}, {x: 14, y: 7}, {x: 14, y: 4}, {x: 10, y: 0}], inner: [[{x: 5, y: 1}, {x: 10, y: 1}, {x: 13, y: 4}, {x: 13, y: 7}, {x: 10, y: 10}, {x: 5, y: 10}, {x: 2, y: 7}, {x: 2, y: 4}, {x: 4, y: 2}]]}, {outer: [{x: 6, y: 4}, {x: 4, y: 5}, {x: 4, y: 7}, {x: 6, y: 8}, {x: 10, y: 8}, {x: 10, y: 4}], inner: [[{x: 6, y: 5}, {x: 9, y: 5}, {x: 9, y: 7}, {x: 6, y: 7}, {x: 4, y: 6}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 5, y: 0}, {x: 1, y: 4}, {x: 1, y: 7}, {x: 5, y: 11}, {x: 7, y: 11},
          {x: 10, y: 11}, {x: 14, y: 7}, {x: 14, y: 4}, {x: 10, y: 0}, {x: 7, y: 0}],
         inner: [
           [{x: 5, y: 10}, {x: 2, y: 7}, {x: 2, y: 4}, {x: 5, y: 1}, {x: 10, y: 1},
             {x: 13, y: 4}, {x: 13, y: 7}, {x: 10, y: 10}]
         ]},
        {outer: [{x: 6, y: 4}, {x: 4, y: 5}, {x: 4, y: 7}, {x: 6, y: 8}, {x: 7, y: 8},
          {x: 10, y: 8}, {x: 10, y: 4}, {x: 7, y: 4}],
         inner: [[{x: 6, y: 7}, {x: 4, y: 6}, {x: 6, y: 5}, {x: 9, y: 5}, {x: 9, y: 7}]]}
      ])
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
      expect(result.points).to eq([{outer: [{x: 1, y: 0}, {x: 1, y: 4}, {x: 5, y: 4}, {x: 7, y: 4}, {x: 7, y: 0}, {x: 5, y: 0}], inner: [[{x: 2, y: 3}, {x: 2, y: 1}, {x: 6, y: 1}, {x: 6, y: 3}]]}, {outer: [{x: 10, y: 0}, {x: 10, y: 4}, {x: 12, y: 4}, {x: 16, y: 4}, {x: 16, y: 0}, {x: 12, y: 0}], inner: [[{x: 11, y: 3}, {x: 11, y: 1}, {x: 15, y: 1}, {x: 15, y: 3}]]}, {outer: [{x: 20, y: 0}, {x: 20, y: 4}, {x: 25, y: 4}, {x: 26, y: 4}, {x: 26, y: 0}, {x: 25, y: 0}], inner: [[{x: 21, y: 1}, {x: 25, y: 1}, {x: 25, y: 3}, {x: 21, y: 3}, {x: 21, y: 2}]]}, {outer: [{x: 29, y: 0}, {x: 29, y: 4}, {x: 35, y: 4}, {x: 35, y: 0}, {x: 32, y: 0}], inner: [[{x: 30, y: 3}, {x: 30, y: 1}, {x: 34, y: 1}, {x: 34, y: 3}]]}])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 5, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 1, y: 0}, {x: 1, y: 4}, {x: 7, y: 4}, {x: 7, y: 0}], inner: [[{x: 2, y: 1}, {x: 6, y: 1}, {x: 6, y: 3}, {x: 2, y: 3}, {x: 2, y: 2}]]}, {outer: [{x: 10, y: 0}, {x: 10, y: 4}, {x: 15, y: 4}, {x: 16, y: 4}, {x: 16, y: 0}, {x: 15, y: 0}], inner: [[{x: 11, y: 1}, {x: 15, y: 1}, {x: 15, y: 3}, {x: 11, y: 3}, {x: 11, y: 2}]]}, {outer: [{x: 20, y: 0}, {x: 20, y: 4}, {x: 26, y: 4}, {x: 26, y: 0}, {x: 23, y: 0}], inner: [[{x: 21, y: 3}, {x: 21, y: 1}, {x: 25, y: 1}, {x: 25, y: 3}]]}, {outer: [{x: 29, y: 0}, {x: 29, y: 4}, {x: 31, y: 4}, {x: 35, y: 4}, {x: 35, y: 0}, {x: 31, y: 0}], inner: [[{x: 30, y: 3}, {x: 30, y: 1}, {x: 34, y: 1}, {x: 34, y: 3}]]}])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 1, y: 0}, {x: 1, y: 4}, {x: 7, y: 4}, {x: 7, y: 0}], inner: [[{x: 2, y: 1}, {x: 6, y: 1}, {x: 6, y: 3}, {x: 2, y: 3}, {x: 2, y: 2}]]}, {outer: [{x: 10, y: 0}, {x: 10, y: 4}, {x: 16, y: 4}, {x: 16, y: 0}], inner: [[{x: 11, y: 1}, {x: 15, y: 1}, {x: 15, y: 3}, {x: 11, y: 3}, {x: 11, y: 2}]]}, {outer: [{x: 20, y: 0}, {x: 20, y: 4}, {x: 26, y: 4}, {x: 26, y: 0}], inner: [[{x: 21, y: 1}, {x: 25, y: 1}, {x: 25, y: 3}, {x: 21, y: 3}, {x: 21, y: 2}]]}, {outer: [{x: 29, y: 0}, {x: 29, y: 4}, {x: 35, y: 4}, {x: 35, y: 0}], inner: [[{x: 30, y: 1}, {x: 34, y: 1}, {x: 34, y: 3}, {x: 30, y: 3}, {x: 30, y: 2}]]}])
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 40),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 7, y: 0}, {x: 7, y: 4}, {x: 1, y: 4}, {x: 1, y: 0}], inner: [[{x: 6, y: 1}, {x: 2, y: 1}, {x: 2, y: 3}, {x: 6, y: 3}, {x: 6, y: 2}]]}, {outer: [{x: 16, y: 0}, {x: 16, y: 4}, {x: 10, y: 4}, {x: 10, y: 0}], inner: [[{x: 15, y: 1}, {x: 11, y: 1}, {x: 11, y: 3}, {x: 15, y: 3}, {x: 15, y: 2}]]}, {outer: [{x: 26, y: 0}, {x: 26, y: 4}, {x: 20, y: 4}, {x: 20, y: 0}], inner: [[{x: 25, y: 1}, {x: 21, y: 1}, {x: 21, y: 3}, {x: 25, y: 3}, {x: 25, y: 2}]]}, {outer: [{x: 35, y: 0}, {x: 35, y: 4}, {x: 29, y: 4}, {x: 29, y: 0}], inner: [[{x: 34, y: 1}, {x: 30, y: 1}, {x: 30, y: 3}, {x: 34, y: 3}, {x: 34, y: 2}]]}])
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
      expect(result.points).to eq([{outer: [{x: 1, y: 0}, {x: 1, y: 4}, {x: 4, y: 4}, {x: 4, y: 0}], inner: []}, {outer: [{x: 7, y: 0}, {x: 7, y: 4}, {x: 9, y: 4}, {x: 10, y: 4}, {x: 10, y: 0}, {x: 9, y: 0}], inner: []}, {outer: [{x: 13, y: 0}, {x: 13, y: 4}, {x: 16, y: 4}, {x: 16, y: 0}], inner: [[{x: 13, y: 1}, {x: 16, y: 1}, {x: 16, y: 3}, {x: 13, y: 3}, {x: 13, y: 2}]]}, {outer: [{x: 19, y: 0}, {x: 19, y: 4}, {x: 22, y: 4}, {x: 22, y: 0}], inner: []}, {outer: [{x: 24, y: 0}, {x: 24, y: 4}, {x: 27, y: 4}, {x: 27, y: 0}], inner: []}, {outer: [{x: 30, y: 0}, {x: 30, y: 4}, {x: 33, y: 4}, {x: 33, y: 0}], inner: []}, {outer: [{x: 37, y: 0}, {x: 37, y: 4}, {x: 39, y: 4}, {x: 40, y: 4}, {x: 40, y: 0}, {x: 39, y: 0}], inner: [[{x: 37, y: 3}, {x: 37, y: 1}, {x: 40, y: 1}, {x: 40, y: 3}]]}, {outer: [{x: 43, y: 0}, {x: 43, y: 4}, {x: 46, y: 4}, {x: 46, y: 0}], inner: []}])
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
      expect(result.points).to eq([{outer: [{x: 5, y: 0}, {x: 1, y: 4}, {x: 1, y: 7}, {x: 5, y: 11}, {x: 7, y: 11}, {x: 10, y: 11}, {x: 14, y: 7}, {x: 14, y: 4}, {x: 10, y: 0}, {x: 7, y: 0}],
                                    inner: [[{x: 4, y: 8}, {x: 3, y: 7}, {x: 3, y: 4}, {x: 4, y: 3}, {x: 11, y: 3}, {x: 12, y: 4}, {x: 12, y: 7}, {x: 11, y: 8}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 7, y: 0}, {x: 10, y: 0}, {x: 14, y: 4}, {x: 14, y: 7}, {x: 10, y: 11}, {x: 7, y: 11}, {x: 5, y: 11}, {x: 1, y: 7}, {x: 1, y: 4}, {x: 5, y: 0}],
                                    inner: [[{x: 4, y: 3}, {x: 3, y: 4}, {x: 3, y: 7}, {x: 4, y: 8}, {x: 11, y: 8}, {x: 12, y: 7}, {x: 12, y: 4}, {x: 11, y: 3}]]}])
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
      expect(result.points).to eq([{outer: [{x: 7, y: 0}, {x: 15, y: 0}, {x: 15, y: 16}, {x: 7, y: 16}, {x: 0, y: 16}, {x: 0, y: 0}], inner: [[{x: 4, y: 2}, {x: 3, y: 3}, {x: 3, y: 6}, {x: 4, y: 7}, {x: 7, y: 7}, {x: 7, y: 6}, {x: 8, y: 5}, {x: 8, y: 4}, {x: 7, y: 3}, {x: 7, y: 2}], [{x: 4, y: 10}, {x: 3, y: 11}, {x: 3, y: 14}, {x: 4, y: 15}, {x: 7, y: 15}, {x: 7, y: 14}, {x: 8, y: 13}, {x: 8, y: 12}, {x: 7, y: 11}, {x: 7, y: 10}]]}])
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
      expect(result.points).to eq([
        {outer: [{x: 7, y: 0}, {x: 11, y: 0}, {x: 14, y: 3}, {x: 14, y: 6}, {x: 11, y: 9},
          {x: 7, y: 9}, {x: 4, y: 9}, {x: 1, y: 6}, {x: 1, y: 3}, {x: 4, y: 0}],
         inner: [[{x: 4, y: 2}, {x: 3, y: 3}, {x: 3, y: 6}, {x: 4, y: 7}, {x: 7, y: 7},
           {x: 7, y: 6}, {x: 8, y: 5}, {x: 8, y: 4}, {x: 7, y: 3}, {x: 7, y: 2}]]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 4, y: 0}, {x: 1, y: 3}, {x: 1, y: 6}, {x: 4, y: 9}, {x: 7, y: 9}, {x: 11, y: 9}, {x: 14, y: 6}, {x: 14, y: 3}, {x: 11, y: 0}, {x: 7, y: 0}],
         inner: [[{x: 4, y: 7}, {x: 3, y: 6}, {x: 3, y: 3}, {x: 4, y: 2}, {x: 7, y: 2},
           {x: 7, y: 3}, {x: 8, y: 4}, {x: 8, y: 5}, {x: 7, y: 6}, {x: 7, y: 7}]]}
      ])
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
      expect(result.points).to eq([{outer: [{x: 7, y: 0}, {x: 15, y: 0}, {x: 15, y: 9}, {x: 7, y: 9}, {x: 1, y: 9}, {x: 1, y: 0}], inner: [[{x: 7, y: 2}, {x: 3, y: 2}, {x: 3, y: 7}, {x: 7, y: 7}, {x: 7, y: 3}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 1, y: 0}, {x: 1, y: 9}, {x: 7, y: 9}, {x: 15, y: 9}, {x: 15, y: 0}, {x: 7, y: 0}], inner: [[{x: 3, y: 2}, {x: 7, y: 2}, {x: 7, y: 7}, {x: 3, y: 7}, {x: 3, y: 3}]]}])
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
      expect(result.points).to eq([
        {outer: [{x: 7, y: 0}, {x: 11, y: 0}, {x: 14, y: 3}, {x: 14, y: 6}, {x: 11, y: 9}, {x: 7, y: 9}, {x: 4, y: 9}, {x: 1, y: 6}, {x: 1, y: 3}, {x: 4, y: 0}],
         inner: [
           [{x: 5, y: 4}, {x: 5, y: 5}, {x: 7, y: 6}, {x: 8, y: 7}, {x: 11, y: 7}, {x: 11, y: 2}, {x: 8, y: 2}, {x: 7, y: 3}]
         ]}
      ])
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
      expect(result.points).to eq([{outer:
        [{x: 7, y: 0}, {x: 7, y: 3}, {x: 5, y: 4}, {x: 2, y: 5}, {x: 1, y: 6}, {x: 1, y: 9}, {x: 2, y: 10},
          {x: 7, y: 11}, {x: 12, y: 11}, {x: 14, y: 9}, {x: 14, y: 6}, {x: 13, y: 5}, {x: 13, y: 0}], inner: []}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 16),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 7, y: 0}, {x: 13, y: 0}, {x: 13, y: 5}, {x: 14, y: 6}, {x: 14, y: 9}, {x: 12, y: 11}, {x: 7, y: 11}, {x: 2, y: 10}, {x: 1, y: 9}, {x: 1, y: 6}, {x: 2, y: 5}, {x: 5, y: 4}, {x: 7, y: 3}, {x: 7, y: 1}], inner: []}])
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
      expect(result.points).to eq([
        {outer: [{x: 4, y: 0}, {x: 1, y: 3}, {x: 1, y: 6}, {x: 4, y: 9}, {x: 6, y: 9},
          {x: 12, y: 9}, {x: 15, y: 6}, {x: 15, y: 3}, {x: 12, y: 0}, {x: 6, y: 0}],
         inner: [[{x: 5, y: 6}, {x: 4, y: 5}, {x: 4, y: 4}, {x: 5, y: 3}, {x: 10, y: 3},
           {x: 11, y: 4}, {x: 11, y: 5}, {x: 10, y: 6}]]}
      ])
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
      @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect([{outer: [{x: 3, y: 0}, {x: 0, y: 3}, {x: 0, y: 6}, {x: 3, y: 9}, {x: 3, y: 10}, {x: 6, y: 10}, {x: 13, y: 10}, {x: 18, y: 10}, {x: 18, y: 9}, {x: 21, y: 6}, {x: 21, y: 3}, {x: 18, y: 0}, {x: 13, y: 0}, {x: 6, y: 0}], inner: [[{x: 7, y: 2}, {x: 8, y: 3}, {x: 7, y: 4}, {x: 4, y: 4}, {x: 3, y: 3}, {x: 4, y: 2}], [{x: 8, y: 6}, {x: 8, y: 8}, {x: 3, y: 8}, {x: 3, y: 6}], [{x: 11, y: 7}, {x: 11, y: 3}, {x: 18, y: 3}, {x: 18, y: 7}]]}, {outer: [{x: 14, y: 4}, {x: 14, y: 6}, {x: 15, y: 6}, {x: 15, y: 4}], inner: []}])
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
      expect(result.points).to eq([{outer: [{x: 3, y: 0}, {x: 0, y: 3}, {x: 0, y: 6}, {x: 3, y: 9}, {x: 3, y: 10}, {x: 6, y: 10}, {x: 13, y: 10}, {x: 18, y: 10}, {x: 18, y: 9}, {x: 21, y: 6}, {x: 21, y: 3}, {x: 18, y: 0}, {x: 13, y: 0}, {x: 6, y: 0}], inner: [[{x: 8, y: 8}, {x: 6, y: 9}, {x: 3, y: 8}, {x: 3, y: 5}, {x: 6, y: 4}, {x: 8, y: 5}, {x: 11, y: 5}, {x: 11, y: 3}, {x: 18, y: 3}, {x: 18, y: 7}]]}])
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
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 4}, {x: 10, y: 4}, {x: 21, y: 4}, {x: 21, y: 0}, {x: 10, y: 0}], inner: [[{x: 9, y: 3}, {x: 9, y: 1}, {x: 21, y: 1}, {x: 21, y: 3}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 22),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 10, y: 0}, {x: 21, y: 0}, {x: 21, y: 4}, {x: 10, y: 4}, {x: 0, y: 4}, {x: 0, y: 0}], inner: [[{x: 9, y: 1}, {x: 9, y: 3}, {x: 21, y: 3}, {x: 21, y: 1}]]}])
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
      expect(result.points).to eq([
        {outer: [{x: 2, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 0, y: 3}, {x: 0, y: 7}, {x: 1, y: 8}, {x: 1, y: 9}, {x: 3, y: 11}, {x: 6, y: 11}, {x: 13, y: 11}, {x: 13, y: 10}, {x: 6, y: 10}, {x: 3, y: 9}, {x: 3, y: 7}, {x: 6, y: 6}, {x: 13, y: 6}, {x: 13, y: 0}, {x: 6, y: 0}],
         inner: [[{x: 3, y: 4}, {x: 3, y: 2}, {x: 11, y: 2}, {x: 11, y: 4}]]}
      ])
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
      expect(result.points).to eq([{outer: [{x: 2, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 0, y: 3}, {x: 0, y: 7}, {x: 1, y: 8}, {x: 1, y: 9}, {x: 3, y: 11}, {x: 6, y: 11}, {x: 13, y: 11}, {x: 18, y: 11}, {x: 19, y: 10}, {x: 19, y: 9}, {x: 21, y: 7}, {x: 21, y: 3}, {x: 20, y: 2}, {x: 20, y: 1}, {x: 19, y: 0}, {x: 13, y: 0}, {x: 6, y: 0}], inner: [[{x: 3, y: 4}, {x: 3, y: 2}, {x: 11, y: 2}, {x: 11, y: 4}], [{x: 6, y: 10}, {x: 3, y: 9}, {x: 3, y: 7}, {x: 6, y: 6}, {x: 16, y: 7}, {x: 16, y: 9}]]}])
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
      expect(result.points).to eq([{outer: [{x: 5, y: 0}, {x: 11, y: 0}, {x: 11, y: 7}, {x: 5, y: 7}, {x: 0, y: 7}, {x: 0, y: 6}, {x: 5, y: 5}, {x: 6, y: 4}, {x: 6, y: 3}, {x: 5, y: 2}, {x: 0, y: 1}, {x: 0, y: 0}], inner: []}])
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
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 7}, {x: 5, y: 7}, {x: 11, y: 7}, {x: 11, y: 0}, {x: 5, y: 0}],
         inner: [
           [{x: 4, y: 4}, {x: 4, y: 3}, {x: 5, y: 2}, {x: 11, y: 2}, {x: 11, y: 5}, {x: 5, y: 5}]
         ]}
      ])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 12),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 5, y: 0}, {x: 11, y: 0}, {x: 11, y: 7}, {x: 5, y: 7}, {x: 0, y: 7}, {x: 0, y: 0}],
         inner: [
           [{x: 4, y: 3}, {x: 4, y: 4}, {x: 5, y: 5}, {x: 11, y: 5}, {x: 11, y: 2}, {x: 5, y: 2}]
         ]}
      ])
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
      expect(result.points).to eq([{
        outer: [{x: 0, y: 0}, {x: 0, y: 7}, {x: 4, y: 7}, {x: 19, y: 7}, {x: 19, y: 0}, {x: 4, y: 0}],
        inner: [
          [{x: 8, y: 4}, {x: 8, y: 3}, {x: 9, y: 2},
            {x: 14, y: 2}, {x: 15, y: 3}, {x: 15, y: 4}, {x: 14, y: 5}, {x: 9, y: 5}]
        ]
      }])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 4, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{
        outer: [{x: 4, y: 0}, {x: 19, y: 0}, {x: 19, y: 7}, {x: 4, y: 7}, {x: 0, y: 7}, {x: 0, y: 0}],
        inner: [
          [{x: 8, y: 3}, {x: 8, y: 4}, {x: 9, y: 5},
            {x: 14, y: 5}, {x: 15, y: 4}, {x: 15, y: 3}, {x: 14, y: 2}, {x: 9, y: 2}]
        ]
      }])
    end

    it "syllable el (sew technic)" do
      #        --------*--------*---------
      chunk = "XXXXXXXXXXXXXXXXXXX        " \
              " XXXXXXXXXX  XXXXX         " \
              "  XXX    XX   XXX          " \
              "  XXX     X   XXX          " \
              "  XXX         XXX          " \
              "  XXX     X   XXX          " \
              "  XXX    XX   XXX          " \
              "  XXXXXXXXX   XXX          " \
              "  XXXXXXXXX   XXX          " \
              "  XXXXXXXXX   XXX          " \
              "  XXX    XX   XXX          " \
              "  XXX     X   XXX          " \
              "  XXX         XXX          " \
              "  XXX     X   XXX         X" \
              "  XXX    XX   XXX        XX" \
              " XXXXXXXXXX  XXXXXXXXXXXXXX" \
              "XXXXXXXXXXXXXXXXXXXXXXXXXXX"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 27),
        matcher: @matcher,
        options: {number_of_tiles: 3, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 8, y: 0}, {x: 17, y: 0}, {x: 18, y: 0}, {x: 16, y: 2}, {x: 16, y: 14}, {x: 17, y: 15},
          {x: 25, y: 14}, {x: 26, y: 13}, {x: 26, y: 16}, {x: 8, y: 16}, {x: 0, y: 16}, {x: 2, y: 14},
          {x: 2, y: 2}, {x: 0, y: 0}],
         inner: [[{x: 4, y: 2}, {x: 4, y: 6}, {x: 8, y: 7}, {x: 10, y: 5}, {x: 10, y: 11}, {x: 8, y: 9}, {x: 4, y: 10}, {x: 4, y: 14}, {x: 9, y: 14}, {x: 10, y: 13}, {x: 10, y: 15}, {x: 13, y: 15}, {x: 14, y: 14}, {x: 14, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 3}, {x: 9, y: 2}]]}
])
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
      expect(result.points).to eq([{outer: [{x: 8, y: 0}, {x: 17, y: 0}, {x: 17, y: 1}, {x: 16, y: 2}, {x: 16, y: 14}, {x: 17, y: 15}, {x: 17, y: 16}, {x: 8, y: 16}, {x: 0, y: 16}, {x: 2, y: 14}, {x: 2, y: 2}, {x: 0, y: 0}], inner: [[{x: 4, y: 2}, {x: 4, y: 6}, {x: 8, y: 7}, {x: 10, y: 5}, {x: 10, y: 11}, {x: 8, y: 9}, {x: 4, y: 10}, {x: 4, y: 14}, {x: 9, y: 14}, {x: 10, y: 13}, {x: 10, y: 15}, {x: 13, y: 15}, {x: 14, y: 14}, {x: 14, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 3}, {x: 9, y: 2}]]}])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 18),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 2, y: 2}, {x: 2, y: 14}, {x: 0, y: 16}, {x: 8, y: 16}, {x: 17, y: 16}, {x: 17, y: 15}, {x: 16, y: 14}, {x: 16, y: 2}, {x: 17, y: 1}, {x: 17, y: 0}, {x: 8, y: 0}], inner: [[{x: 4, y: 14}, {x: 4, y: 10}, {x: 8, y: 9}, {x: 10, y: 11}, {x: 10, y: 5}, {x: 8, y: 7}, {x: 4, y: 6}, {x: 4, y: 2}, {x: 9, y: 2}, {x: 10, y: 3}, {x: 10, y: 1}, {x: 13, y: 1}, {x: 14, y: 2}, {x: 14, y: 14}, {x: 13, y: 15}, {x: 10, y: 15}, {x: 10, y: 13}, {x: 9, y: 14}]]}])
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
      expect(result.points).to eq([
        {outer: [{x: 8, y: 0}, {x: 17, y: 0}, {x: 17, y: 1}, {x: 16, y: 2}, {x: 16, y: 14}, {x: 17, y: 15}, {x: 17, y: 16}, {x: 8, y: 16}, {x: 0, y: 16}, {x: 2, y: 14}, {x: 2, y: 2}, {x: 0, y: 0}],
         inner: [
           [{x: 4, y: 2}, {x: 4, y: 4}, {x: 8, y: 5}, {x: 10, y: 4}, {x: 10, y: 12}, {x: 8, y: 11}, {x: 4, y: 12}, {x: 4, y: 14}, {x: 10, y: 14}, {x: 10, y: 15}, {x: 13, y: 15}, {x: 14, y: 14}, {x: 14, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}],
           [{x: 4, y: 7}, {x: 4, y: 9}, {x: 10, y: 9}, {x: 10, y: 7}]
         ]}
      ])
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
      expect(result.points).to eq([{outer: [{x: 8, y: 0}, {x: 17, y: 0}, {x: 17, y: 1}, {x: 16, y: 2}, {x: 16, y: 19}, {x: 17, y: 20}, {x: 17, y: 21}, {x: 8, y: 21}, {x: 0, y: 21}, {x: 2, y: 19}, {x: 2, y: 2}, {x: 0, y: 0}], inner: [[{x: 4, y: 2}, {x: 4, y: 4}, {x: 8, y: 5}, {x: 10, y: 4}, {x: 10, y: 17}, {x: 8, y: 16}, {x: 4, y: 17}, {x: 4, y: 19}, {x: 10, y: 19}, {x: 10, y: 20}, {x: 13, y: 20}, {x: 14, y: 19}, {x: 14, y: 2}, {x: 13, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}], [{x: 4, y: 7}, {x: 4, y: 9}, {x: 10, y: 9}, {x: 10, y: 7}], [{x: 4, y: 12}, {x: 4, y: 14}, {x: 10, y: 14}, {x: 10, y: 12}]]}])
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
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 12}, {x: 9, y: 12}, {x: 0, y: 12}, {x: 0, y: 0}], inner: [[{x: 0, y: 1}, {x: 0, y: 11}, {x: 19, y: 11}, {x: 19, y: 1}]]}, {outer: [{x: 9, y: 2}, {x: 16, y: 2}, {x: 16, y: 10}, {x: 9, y: 10}, {x: 3, y: 10}, {x: 3, y: 7}, {x: 7, y: 7}, {x: 9, y: 8}, {x: 10, y: 7}, {x: 10, y: 5}, {x: 9, y: 4}, {x: 7, y: 5}, {x: 3, y: 5}, {x: 3, y: 2}], inner: [[{x: 3, y: 3}, {x: 3, y: 4}, {x: 7, y: 4}, {x: 10, y: 4}, {x: 10, y: 8}, {x: 7, y: 8}, {x: 3, y: 8}, {x: 3, y: 9}, {x: 16, y: 9}, {x: 16, y: 3}]]}])
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
      expect(result.points).to eq([
        {outer: [{x: 6, y: 0}, {x: 13, y: 0}, {x: 13, y: 8}, {x: 6, y: 8}, {x: 0, y: 8}, {x: 0, y: 5}, {x: 4, y: 5}, {x: 6, y: 6}, {x: 7, y: 5}, {x: 7, y: 3}, {x: 6, y: 2}, {x: 4, y: 3}, {x: 0, y: 3}, {x: 0, y: 0}],
         inner: [
           [{x: 0, y: 1}, {x: 0, y: 2}, {x: 4, y: 2},
             {x: 7, y: 2}, {x: 7, y: 6},
             {x: 4, y: 6}, {x: 0, y: 6}, {x: 0, y: 7},
             {x: 13, y: 7}, {x: 13, y: 1}]
         ]}
      ])
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
      expect(result.points).to eq([
        {outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 9}, {x: 9, y: 9}, {x: 0, y: 9}, {x: 0, y: 0}],
         inner: [[{x: 3, y: 2}, {x: 3, y: 3}, {x: 7, y: 3},
           {x: 9, y: 3}, {x: 9, y: 6},
           {x: 7, y: 6}, {x: 3, y: 6}, {x: 3, y: 7},
           {x: 16, y: 7}, {x: 16, y: 2}]]}
      ])
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
        options: {number_of_tiles: 3, versus: :a, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 10}, {x: 9, y: 10}, {x: 29, y: 10}, {x: 29, y: 0}, {x: 9, y: 0}], inner: [[{x: 2, y: 8}, {x: 2, y: 7}, {x: 19, y: 7}, {x: 19, y: 8}], [{x: 18, y: 4}, {x: 18, y: 3}, {x: 9, y: 3}, {x: 7, y: 3}, {x: 7, y: 4}, {x: 2, y: 4}, {x: 2, y: 2}, {x: 9, y: 1}, {x: 27, y: 2}, {x: 27, y: 4}]]}])
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
      expect(result.points).to eq([
        {outer: [{x: 19, y: 0}, {x: 19, y: 8}, {x: 0, y: 8}, {x: 0, y: 0}],
         inner: [[{x: 16, y: 2}, {x: 1, y: 2}, {x: 1, y: 6}, {x: 16, y: 6}, {x: 6, y: 5}, {x: 6, y: 3}]]}
])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 8}, {x: 9, y: 8}, {x: 0, y: 8}, {x: 0, y: 0}],
         inner: [[{x: 1, y: 2}, {x: 1, y: 6}, {x: 16, y: 6}, {x: 9, y: 5}, {x: 6, y: 5}, {x: 6, y: 3}, {x: 9, y: 3}, {x: 16, y: 2}]]}
])
    end

    it "half moon problem 2" do
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
      expect(result.points).to eq([
        {outer: [{x: 19, y: 0}, {x: 19, y: 13}, {x: 0, y: 13}, {x: 0, y: 0}],
         inner: [
          [{x: 16, y: 2}, {x: 1, y: 2}, {x: 1, y: 11}, {x: 16, y: 11}, {x: 4, y: 10}, {x: 4, y: 3}],
          [{x: 16, y: 5}, {x: 6, y: 5}, {x: 6, y: 8}, {x: 16, y: 8}, {x: 8, y: 7}, {x: 8, y: 6}]
]}
])

      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([
        {outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 13}, {x: 9, y: 13}, {x: 0, y: 13}, {x: 0, y: 0}],
         inner: [
          [{x: 1, y: 2}, {x: 1, y: 11}, {x: 16, y: 11}, {x: 9, y: 10}, {x: 4, y: 10},
            {x: 4, y: 3}, {x: 9, y: 3}, {x: 16, y: 2}],
          [{x: 16, y: 8}, {x: 9, y: 7}, {x: 8, y: 7}, {x: 8, y: 6}, {x: 9, y: 6},
            {x: 16, y: 5}, {x: 6, y: 5}, {x: 6, y: 8}]
]}
])
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
      expect(result.points).to eq([{
        outer: [{x: 11, y: 0}, {x: 23, y: 0}, {x: 23, y: 21}, {x: 11, y: 21}, {x: 0, y: 21}, {x: 0, y: 0}],
        inner: [
          [{x: 1, y: 2}, {x: 1, y: 19}, {x: 16, y: 19}, {x: 11, y: 18},
            {x: 4, y: 18}, {x: 4, y: 3}, {x: 11, y: 3}, {x: 16, y: 2}],
          [{x: 16, y: 13}, {x: 16, y: 12}, {x: 12, y: 11}, {x: 12, y: 10},
            {x: 16, y: 9}, {x: 16, y: 8}, {x: 9, y: 8}, {x: 9, y: 13}],
            [{x: 16, y: 16}, {x: 11, y: 15}, {x: 8, y: 15}, {x: 8, y: 6},
              {x: 11, y: 6}, {x: 16, y: 5}, {x: 5, y: 5}, {x: 5, y: 16}]
]
      }])
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
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 11}, {x: 9, y: 11}, {x: 19, y: 11}, {x: 19, y: 0}, {x: 9, y: 0}],
         inner: [
          [{x: 1, y: 9}, {x: 1, y: 2}, {x: 16, y: 2}, {x: 9, y: 3}, {x: 4, y: 3}, {x: 4, y: 8},
           {x: 9, y: 8}, {x: 13, y: 8}, {x: 13, y: 6}, {x: 12, y: 6}, {x: 9, y: 7}, {x: 6, y: 6},
           {x: 6, y: 5}, {x: 9, y: 4}, {x: 16, y: 5}, {x: 16, y: 9}]
]}
])
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
      expect(result.points).to eq([
        {outer: [{x: 0, y: 0}, {x: 0, y: 14}, {x: 9, y: 14}, {x: 19, y: 14}, {x: 19, y: 0}, {x: 9, y: 0}],
         inner: [[{x: 1, y: 12}, {x: 1, y: 2}, {x: 16, y: 2}, {x: 9, y: 3}, {x: 4, y: 3}, {x: 4, y: 11},
          {x: 9, y: 11}, {x: 13, y: 11}, {x: 13, y: 6}, {x: 8, y: 6}, {x: 8, y: 7}, {x: 12, y: 8},
          {x: 12, y: 9}, {x: 9, y: 10}, {x: 6, y: 9}, {x: 6, y: 5}, {x: 9, y: 4}, {x: 16, y: 5}, {x: 16, y: 12}]]}
])
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
      expect(result.points).to eq([
        {outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 13}, {x: 9, y: 13}, {x: 0, y: 13}, {x: 0, y: 0}],
         inner: [
          [{x: 3, y: 2}, {x: 9, y: 3}, {x: 15, y: 3}, {x: 15, y: 10}, {x: 9, y: 10}, {x: 3, y: 11}, {x: 18, y: 11}, {x: 18, y: 2}],
          [{x: 3, y: 5}, {x: 9, y: 6}, {x: 11, y: 6}, {x: 11, y: 7}, {x: 9, y: 7}, {x: 3, y: 8}, {x: 13, y: 8}, {x: 13, y: 5}]
]}
])
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
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 13}, {x: 9, y: 13}, {x: 0, y: 13}, {x: 0, y: 0}], inner: [[{x: 1, y: 2}, {x: 1, y: 11}, {x: 16, y: 11}, {x: 9, y: 10}, {x: 4, y: 10}, {x: 4, y: 3}, {x: 9, y: 3}, {x: 11, y: 3}, {x: 11, y: 4}, {x: 9, y: 4}, {x: 6, y: 5}, {x: 9, y: 6}, {x: 16, y: 5}, {x: 15, y: 4}, {x: 15, y: 3}, {x: 16, y: 2}], [{x: 16, y: 8}, {x: 6, y: 8}]]}])
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
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 19}, {x: 9, y: 19}, {x: 0, y: 19}, {x: 0, y: 0}], inner: [[{x: 1, y: 2}, {x: 1, y: 17}, {x: 16, y: 17}, {x: 9, y: 16}, {x: 4, y: 16}, {x: 4, y: 3}, {x: 9, y: 3}, {x: 11, y: 3}, {x: 11, y: 10}, {x: 9, y: 10}, {x: 6, y: 11}, {x: 9, y: 12}, {x: 16, y: 11}, {x: 16, y: 2}], [{x: 16, y: 14}, {x: 6, y: 14}], [{x: 6, y: 5}, {x: 6, y: 8}, {x: 10, y: 8}, {x: 10, y: 5}]]}])
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
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 19}, {x: 9, y: 19}, {x: 0, y: 19}, {x: 0, y: 0}], inner: [[{x: 1, y: 2}, {x: 1, y: 17}, {x: 16, y: 17}, {x: 9, y: 16}, {x: 4, y: 16}, {x: 4, y: 3}, {x: 9, y: 3}, {x: 11, y: 3}, {x: 11, y: 4}, {x: 16, y: 4}, {x: 16, y: 2}], [{x: 16, y: 14}, {x: 6, y: 14}], [{x: 16, y: 11}, {x: 16, y: 7}, {x: 11, y: 7}, {x: 11, y: 10}, {x: 6, y: 11}], [{x: 10, y: 8}, {x: 10, y: 5}, {x: 6, y: 5}, {x: 6, y: 8}]]}])
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
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 19}, {x: 9, y: 19}, {x: 0, y: 19}, {x: 0, y: 1}, {x: 7, y: 0}], inner: [[{x: 6, y: 2}, {x: 6, y: 3}, {x: 1, y: 4}, {x: 1, y: 17}, {x: 16, y: 17}, {x: 9, y: 16}, {x: 4, y: 16}, {x: 4, y: 5}, {x: 6, y: 5}, {x: 6, y: 8}, {x: 9, y: 9}, {x: 10, y: 8}, {x: 10, y: 5}, {x: 16, y: 4}, {x: 16, y: 2}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 9, y: 3}, {x: 9, y: 2}], [{x: 16, y: 14}, {x: 6, y: 14}], [{x: 16, y: 11}, {x: 16, y: 7}, {x: 11, y: 7}, {x: 11, y: 10}, {x: 6, y: 11}]]}])
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
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 27}, {x: 9, y: 27}, {x: 0, y: 27}, {x: 0, y: 0}], inner: [[{x: 1, y: 2}, {x: 1, y: 25}, {x: 12, y: 25}, {x: 12, y: 24}, {x: 9, y: 23}, {x: 4, y: 23}, {x: 4, y: 3}, {x: 9, y: 3}, {x: 9, y: 4}, {x: 6, y: 5}, {x: 9, y: 6}, {x: 11, y: 5}, {x: 12, y: 4}, {x: 18, y: 3}, {x: 18, y: 2}], [{x: 18, y: 6}, {x: 13, y: 6}, {x: 13, y: 21}, {x: 18, y: 21}, {x: 18, y: 7}], [{x: 17, y: 24}, {x: 13, y: 24}, {x: 13, y: 25}, {x: 17, y: 25}], [{x: 12, y: 21}, {x: 12, y: 20}, {x: 6, y: 20}, {x: 6, y: 21}], [{x: 12, y: 17}, {x: 12, y: 16}, {x: 6, y: 16}, {x: 6, y: 17}], [{x: 12, y: 13}, {x: 12, y: 12}, {x: 6, y: 12}, {x: 6, y: 13}], [{x: 12, y: 9}, {x: 12, y: 8}, {x: 6, y: 8}, {x: 6, y: 9}]]}])
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
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 29}, {x: 9, y: 29}, {x: 0, y: 29}, {x: 0, y: 1}, {x: 7, y: 0}], inner: [[{x: 6, y: 2}, {x: 6, y: 3}, {x: 1, y: 4}, {x: 1, y: 27}, {x: 12, y: 27}, {x: 12, y: 26}, {x: 9, y: 25}, {x: 4, y: 25}, {x: 4, y: 5}, {x: 9, y: 5}, {x: 9, y: 6}, {x: 6, y: 7}, {x: 9, y: 8}, {x: 11, y: 7}, {x: 12, y: 6}, {x: 18, y: 5}, {x: 18, y: 4}, {x: 16, y: 3}, {x: 16, y: 2}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 9, y: 3}, {x: 9, y: 2}], [{x: 18, y: 8}, {x: 13, y: 8}, {x: 13, y: 23}, {x: 18, y: 23}, {x: 18, y: 9}], [{x: 17, y: 26}, {x: 13, y: 26}, {x: 13, y: 27}, {x: 17, y: 27}], [{x: 12, y: 23}, {x: 12, y: 22}, {x: 6, y: 22}, {x: 6, y: 23}], [{x: 12, y: 19}, {x: 12, y: 18}, {x: 6, y: 18}, {x: 6, y: 19}], [{x: 12, y: 15}, {x: 12, y: 14}, {x: 6, y: 14}, {x: 6, y: 15}], [{x: 12, y: 11}, {x: 12, y: 10}, {x: 6, y: 10}, {x: 6, y: 11}]]}])
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
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 23}, {x: 9, y: 23}, {x: 19, y: 23}, {x: 19, y: 0}, {x: 9, y: 0}], inner: [[{x: 1, y: 21}, {x: 1, y: 2}, {x: 16, y: 2}, {x: 16, y: 10}, {x: 9, y: 11}, {x: 6, y: 10}, {x: 9, y: 9}, {x: 11, y: 9}, {x: 11, y: 3}, {x: 9, y: 3}, {x: 4, y: 3}, {x: 4, y: 20}, {x: 9, y: 20}, {x: 16, y: 21}], [{x: 6, y: 7}, {x: 6, y: 5}, {x: 10, y: 5}, {x: 10, y: 7}], [{x: 16, y: 13}, {x: 16, y: 18}, {x: 6, y: 18}, {x: 6, y: 17}, {x: 9, y: 16}, {x: 10, y: 16}, {x: 10, y: 15}, {x: 9, y: 15}, {x: 6, y: 14}, {x: 6, y: 13}]]}])
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
      expect(result.points).to eq([{
        outer: [{x: 11, y: 0}, {x: 12, y: 0}, {x: 12, y: 1}, {x: 14, y: 3}, {x: 16, y: 4}, {x: 19, y: 5}, {x: 21, y: 7}, {x: 24, y: 8}, {x: 24, y: 11}, {x: 21, y: 12}, {x: 21, y: 13}, {x: 20, y: 14}, {x: 20, y: 16}, {x: 19, y: 17}, {x: 19, y: 19}, {x: 18, y: 20}, {x: 18, y: 26}, {x: 17, y: 27}, {x: 17, y: 32}, {x: 18, y: 33}, {x: 18, y: 37}, {x: 19, y: 38}, {x: 19, y: 40}, {x: 20, y: 41}, {x: 20, y: 42}, {x: 21, y: 43}, {x: 21, y: 44}, {x: 22, y: 45}, {x: 22, y: 46}, {x: 23, y: 47}, {x: 23, y: 48}, {x: 24, y: 49}, {x: 24, y: 57}, {x: 21, y: 58}, {x: 18, y: 61}, {x: 18, y: 62}, {x: 17, y: 63}, {x: 17, y: 64}, {x: 16, y: 64}, {x: 12, y: 60}, {x: 12, y: 59}, {x: 10, y: 57}, {x: 10, y: 56}, {x: 9, y: 55}, {x: 9, y: 54}, {x: 7, y: 52}, {x: 7, y: 51}, {x: 6, y: 50}, {x: 6, y: 48}, {x: 5, y: 47}, {x: 5, y: 45}, {x: 4, y: 44}, {x: 4, y: 41}, {x: 2, y: 40}, {x: 2, y: 20}, {x: 4, y: 19}, {x: 4, y: 14}, {x: 5, y: 13}, {x: 5, y: 11}, {x: 6, y: 10}, {x: 6, y: 9}, {x: 7, y: 8}, {x: 7, y: 7}, {x: 8, y: 6}, {x: 8, y: 5}, {x: 9, y: 4}, {x: 9, y: 3}, {x: 10, y: 2}, {x: 10, y: 0}], inner: [[{x: 10, y: 3}, {x: 10, y: 4}, {x: 9, y: 5}, {x: 9, y: 6}, {x: 8, y: 7}, {x: 8, y: 8}, {x: 7, y: 9}, {x: 7, y: 10}, {x: 6, y: 11}, {x: 6, y: 13}, {x: 5, y: 14}, {x: 5, y: 16}, {x: 4, y: 17}, {x: 4, y: 21}, {x: 3, y: 22}, {x: 3, y: 29}, {x: 9, y: 29}, {x: 9, y: 26}, {x: 10, y: 25}, {x: 10, y: 20}, {x: 11, y: 18}, {x: 11, y: 16}, {x: 11, y: 20}, {x: 11, y: 22}, {x: 12, y: 15}, {x: 12, y: 13}, {x: 13, y: 12}, {x: 13, y: 11}, {x: 14, y: 10}, {x: 14, y: 9}, {x: 16, y: 7}, {x: 15, y: 6}, {x: 15, y: 5}, {x: 13, y: 4}, {x: 12, y: 3}], [{x: 10, y: 23}, {x: 10, y: 29}, {x: 17, y: 29}, {x: 17, y: 22}, {x: 18, y: 21}, {x: 18, y: 18}, {x: 19, y: 17}, {x: 19, y: 14}, {x: 20, y: 13}, {x: 20, y: 12}, {x: 21, y: 11}, {x: 21, y: 10}, {x: 22, y: 9}, {x: 21, y: 8}, {x: 18, y: 7}, {x: 16, y: 7}, {x: 16, y: 8}, {x: 15, y: 9}, {x: 15, y: 10}, {x: 14, y: 11}, {x: 14, y: 12}, {x: 13, y: 13}, {x: 13, y: 15}, {x: 12, y: 16}, {x: 12, y: 18}, {x: 11, y: 20}, {x: 11, y: 22}, {x: 11, y: 18}, {x: 11, y: 16}], [{x: 10, y: 31}, {x: 10, y: 34}, {x: 11, y: 42}, {x: 11, y: 41}, {x: 11, y: 35}, {x: 11, y: 39}, {x: 12, y: 41}, {x: 12, y: 43}, {x: 13, y: 44}, {x: 13, y: 45}, {x: 14, y: 46}, {x: 14, y: 47}, {x: 15, y: 48}, {x: 15, y: 49}, {x: 16, y: 50}, {x: 16, y: 51}, {x: 20, y: 55}, {x: 22, y: 55}, {x: 24, y: 54}, {x: 24, y: 50}, {x: 23, y: 49}, {x: 23, y: 48}, {x: 22, y: 47}, {x: 22, y: 46}, {x: 20, y: 44}, {x: 20, y: 42}, {x: 18, y: 40}, {x: 18, y: 38}, {x: 17, y: 37}, {x: 17, y: 32}, {x: 16, y: 31}], [{x: 10, y: 39}, {x: 10, y: 33}, {x: 9, y: 32}, {x: 9, y: 31}, {x: 3, y: 31}, {x: 3, y: 38}, {x: 4, y: 39}, {x: 4, y: 42}, {x: 5, y: 43}, {x: 5, y: 45}, {x: 6, y: 46}, {x: 6, y: 48}, {x: 7, y: 49}, {x: 7, y: 50}, {x: 8, y: 51}, {x: 8, y: 52}, {x: 9, y: 53}, {x: 9, y: 54}, {x: 11, y: 56}, {x: 11, y: 57}, {x: 14, y: 60}, {x: 14, y: 61}, {x: 17, y: 61}, {x: 19, y: 59}, {x: 19, y: 58}, {x: 20, y: 57}, {x: 20, y: 56}, {x: 18, y: 55}, {x: 17, y: 54}, {x: 17, y: 53}, {x: 15, y: 51}, {x: 15, y: 50}, {x: 14, y: 49}, {x: 14, y: 48}, {x: 13, y: 47}, {x: 13, y: 46}, {x: 12, y: 45}, {x: 12, y: 43}, {x: 11, y: 35}, {x: 11, y: 39}, {x: 11, y: 42}, {x: 11, y: 41}]]
      }])
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
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 13, y: 0}, {x: 19, y: 6}, {x: 19, y: 9}, {x: 8, y: 20}, {x: 8, y: 21}, {x: 0, y: 21}, {x: 0, y: 0}], inner: [[{x: 5, y: 2}, {x: 6, y: 3}, {x: 11, y: 4}, {x: 11, y: 7}, {x: 18, y: 7}, {x: 18, y: 6}, {x: 14, y: 2}], [{x: 6, y: 5}, {x: 6, y: 4}, {x: 4, y: 2}, {x: 1, y: 2}, {x: 1, y: 7}, {x: 10, y: 7}, {x: 10, y: 6}], [{x: 1, y: 9}, {x: 1, y: 16}, {x: 3, y: 16}, {x: 6, y: 13}, {x: 6, y: 11}, {x: 9, y: 12}, {x: 9, y: 13}, {x: 10, y: 10}, {x: 10, y: 9}], [{x: 6, y: 14}, {x: 1, y: 19}, {x: 8, y: 19}, {x: 18, y: 9}, {x: 11, y: 9}, {x: 11, y: 11}, {x: 9, y: 12}, {x: 9, y: 13}]]}])
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
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 15}, {x: 9, y: 15}, {x: 13, y: 15}, {x: 19, y: 9}, {x: 19, y: 6}, {x: 13, y: 0}, {x: 9, y: 0}], inner: [[{x: 7, y: 13}, {x: 9, y: 11}, {x: 9, y: 12}, {x: 11, y: 11}, {x: 13, y: 9}, {x: 18, y: 9}, {x: 14, y: 13}], [{x: 7, y: 12}, {x: 6, y: 13}, {x: 1, y: 13}, {x: 1, y: 9}, {x: 12, y: 9}, {x: 11, y: 10}, {x: 9, y: 12}, {x: 9, y: 11}], [{x: 1, y: 6}, {x: 1, y: 2}, {x: 4, y: 2}, {x: 6, y: 4}, {x: 11, y: 5}, {x: 12, y: 6}], [{x: 6, y: 3}, {x: 5, y: 2}, {x: 14, y: 2}, {x: 18, y: 6}, {x: 13, y: 6}, {x: 11, y: 4}]]}])
    end

    # this test demonstrate how trace contours on two different areas merging them later considering
    # they share adjacent vertical stripe (one pixel)
    it "merge mode" do
      left = "0000000000" \
              "0000000000" \
              "00        " \
              "00        " \
              "00        " \
              "00        " \
              "00        " \
              "0000000000" \
              "0000000000"
      result_left = @simple_polygon_finder.new(@bitmap_class.new(left, 10),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      right = "0000000000" \
              "0000000000" \
              "      0000" \
              "      0000" \
              "      0000" \
              "      0000" \
              "      0000" \
              "0000000000" \
              "0000000000"
      result_right = @simple_polygon_finder.new(@bitmap_class.new(right, 10),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @merger.new
      step_finder.add_tile(result_left)
      step_finder.add_tile(result_right)
      result = step_finder.process_info

      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 8}, {x: 9, y: 8}, {x: 18, y: 8}, {x: 18, y: 0}, {x: 9, y: 0}], inner: [[{x: 1, y: 6}, {x: 1, y: 2}, {x: 15, y: 2}, {x: 15, y: 6}]]}])
    end

    it "merge mode (example 2)" do
      left = "0000000000" \
              "0000000000" \
              "00      00" \
              "00      00" \
              "0000000000" \
              "0000000000" \
              "00        " \
              "00      00" \
              "00      00" \
              "00        " \
              "0000000000" \
              "0000000000"
      result_left = @simple_polygon_finder.new(@bitmap_class.new(left, 10),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      right = "0000000000" \
              "0000000000" \
              "00    0000" \
              "00    0000" \
              "0000000000" \
              "0000000000" \
              "      0000" \
              "00    0000" \
              "00    0000" \
              "      0000" \
              "0000000000" \
              "0000000000"
      result_right = @simple_polygon_finder.new(@bitmap_class.new(right, 10),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @merger.new
      step_finder.add_tile(result_left)
      step_finder.add_tile(result_right)
      result = step_finder.process_info
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 11}, {x: 9, y: 11}, {x: 18, y: 11}, {x: 18, y: 0}, {x: 9, y: 0}], inner: [[{x: 1, y: 2}, {x: 8, y: 2}, {x: 8, y: 3}, {x: 1, y: 3}], [{x: 1, y: 9}, {x: 1, y: 6}, {x: 15, y: 6}, {x: 15, y: 9}], [{x: 10, y: 2}, {x: 15, y: 2}, {x: 15, y: 3}, {x: 10, y: 3}]]}, {outer: [{x: 8, y: 7}, {x: 8, y: 8}, {x: 9, y: 8}, {x: 10, y: 8}, {x: 10, y: 7}, {x: 9, y: 7}], inner: []}])
    end

    it "merge mode (example 3 vertical)" do
      up = "000000000000" \
           "000000000000" \
           "000      000" \
           "000      000" \
           "000      000"
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 12),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info
      expect(result_up.metadata[:width]).to eq(12)
      expect(result_up.metadata[:height]).to eq(5)

      down = "000      000" \
             "000      000" \
             "000      000" \
             "000000000000" \
             "000000000000"
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 12),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info
      expect(result_down.metadata[:width]).to eq(12)
      expect(result_down.metadata[:height]).to eq(5)

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(12)
      expect(result.metadata[:height]).to eq(9)
      expect(result.points).to eq([{outer: [{x: 0, y: 4}, {x: 0, y: 8}, {x: 11, y: 8}, {x: 11, y: 4}, {x: 11, y: 0}, {x: 0, y: 0}], inner: [[{x: 2, y: 2}, {x: 9, y: 2}, {x: 9, y: 6}, {x: 2, y: 6}]]}])
    end

    it "merge mode (example 4)" do
      left = "0000" \
              "0000" \
              "0000" \
              "00  " \
              "00  " \
              "00  " \
              "00  " \
              "00  " \
              "00  " \
              "0000" \
              "0000" \
              "0000"
      result_left = @simple_polygon_finder.new(@bitmap_class.new(left, 4),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      right = "0000" \
              "0000" \
              "0000" \
              "  00" \
              "  00" \
              "  00" \
              "  00" \
              "  00" \
              "  00" \
              "0000" \
              "0000" \
              "0000"
      result_right = @simple_polygon_finder.new(@bitmap_class.new(right, 4),
        @matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @merger.new
      step_finder.add_tile(result_left)
      step_finder.add_tile(result_right)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(7)
      expect(result.metadata[:height]).to eq(12)
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 11}, {x: 3, y: 11}, {x: 6, y: 11}, {x: 6, y: 0}, {x: 3, y: 0}], inner: [[{x: 1, y: 8}, {x: 1, y: 3}, {x: 5, y: 3}, {x: 5, y: 8}]]}])
    end

    it "merge mode (example 5 vertical)" do
      up = "000000000000" \
           "000000000000" \
           "000      000" \
           "000      000" \
           "000      000"
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      down = "000      000" \
             "000      000" \
             "000      000" \
             "000000000000" \
             "000000000000"
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(12)
      expect(result.metadata[:height]).to eq(9)
      expect(result.points).to eq([{outer: [{x: 11, y: 4}, {x: 11, y: 8}, {x: 0, y: 8}, {x: 0, y: 4}, {x: 0, y: 0}, {x: 11, y: 0}], inner: [[{x: 9, y: 2}, {x: 2, y: 2}, {x: 2, y: 6}, {x: 9, y: 6}]]}])
    end

    it "merge mode (example 6 vertical)" do
      up = "000000000000" \
           "000000000000" \
           "000      000" \
           "000      000"
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      mid = "000      000" \
            "000      000" \
            "000000000000" \
            "000000000000" \
            "000      000" \
            "000      000"
      result_mid = @simple_polygon_finder.new(@bitmap_class.new(mid, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      down = "000      000" \
             "000      000" \
             "000000000000" \
             "000000000000"
      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 12),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {uniq: true, linear: true}}).process_info

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_mid)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(12)
      expect(result.metadata[:height]).to eq(12)
      expect(result.points).to eq([{outer: [{x: 11, y: 3}, {x: 11, y: 8}, {x: 11, y: 11}, {x: 0, y: 11}, {x: 0, y: 8}, {x: 0, y: 3}, {x: 0, y: 0}, {x: 11, y: 0}], inner: [[{x: 9, y: 2}, {x: 2, y: 2}, {x: 2, y: 4}, {x: 9, y: 4}], [{x: 9, y: 7}, {x: 2, y: 7}, {x: 2, y: 9}, {x: 9, y: 9}]]}])
    end

    it "merge mode (example 7 vertical)" do
      up =
        "                                                                 " \
        "                       000000000000000                           " \
        "                    000000000000000000000                        " \
        "              00000000        0        000000                    " \
        "           000000             0            00000                 " \
        "         00000                00              00000              " \
        "       0000                   0                  0000            " \
        "     0000                     0                    000           " \
        "   0000                   0000000                    000         " \
        "00000               00000000000000000000               000       " \
        "000             0000000       0    00000000             000      "

      down =
        "000             0000000       0    00000000             000      " \
        "0000         000000           0          00000            000    " \
        "00000      00000              0             0000           000   " \
        "   00    0000                 0               0000          000  " \
        "    000 000                   0                 0000          00 " \
        "    00000                     00                  000         000" \
        "     00               0000000000000000              000      0000" \
        "     000          000000000      00000000            000    000  " \
        "     000      000000                  0000            00  000    " \
        "      00    00000                        0000          00000     " \
        "       00 0000                             000          000      " \
        "        0000                                 000       000       " \
        "        0000                                   000     000       " \
        "        0000                                     000000000       "

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 65),
        @matcher,
        nil,
        {versus: :o, bounds: true, strict_bounds: true}).process_info

      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 65),
        @matcher,
        nil,
        {versus: :o, bounds: true, strict_bounds: true}).process_info

      step_finder = @vertical_merger.new(options: {compress: {uniq: true, linear: true}})
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(65)
      expect(result.metadata[:height]).to eq(24)
      expect(result.points).to eq([{outer: [{x: 40, y: 2}, {x: 44, y: 3}, {x: 50, y: 5}, {x: 52, y: 6}, {x: 53, y: 7}, {x: 57, y: 9}, {x: 58, y: 10}, {x: 60, y: 11}, {x: 64, y: 15}, {x: 64, y: 16}, {x: 60, y: 18}, {x: 57, y: 21}, {x: 57, y: 23}, {x: 49, y: 23}, {x: 41, y: 19}, {x: 38, y: 18}, {x: 33, y: 17}, {y: 16, x: 33}, {y: 16, x: 26}, {x: 26, y: 17}, {x: 19, y: 18}, {x: 13, y: 20}, {x: 11, y: 21}, {x: 11, y: 23}, {x: 8, y: 23}, {x: 8, y: 21}, {x: 5, y: 18}, {x: 5, y: 16}, {x: 4, y: 15}, {x: 4, y: 14}, {x: 3, y: 13}, {x: 0, y: 12}, {x: 0, y: 9}, {x: 3, y: 8}, {x: 11, y: 4}, {x: 14, y: 3}, {x: 20, y: 2}, {x: 23, y: 1}, {x: 37, y: 1}], inner: [[{x: 55, y: 9}, {x: 49, y: 6}, {x: 43, y: 4}, {x: 39, y: 3}, {y: 2, x: 39}, {y: 2, x: 30}, {x: 30, y: 4}, {x: 31, y: 5}, {x: 30, y: 6}, {x: 30, y: 7}, {x: 32, y: 8}, {x: 39, y: 9}, {x: 45, y: 11}, {x: 51, y: 14}, {x: 52, y: 15}, {x: 54, y: 16}, {x: 55, y: 17}, {y: 19, x: 55}, {y: 19, x: 58}, {x: 58, y: 18}, {x: 60, y: 17}, {x: 62, y: 15}, {x: 62, y: 14}, {x: 60, y: 13}, {x: 58, y: 11}], [{y: 9, x: 35}, {y: 9, x: 30}, {x: 30, y: 11}, {x: 30, y: 14}, {x: 31, y: 15}, {x: 37, y: 16}, {x: 40, y: 17}, {x: 41, y: 18}, {x: 44, y: 19}, {x: 45, y: 20}, {x: 49, y: 22}, {y: 23, x: 49}, {y: 23, x: 55}, {x: 55, y: 21}, {x: 56, y: 20}, {x: 52, y: 16}, {x: 44, y: 12}, {x: 41, y: 11}], [{y: 9, x: 30}, {y: 9, x: 22}, {x: 18, y: 11}, {x: 12, y: 13}, {x: 6, y: 16}, {x: 7, y: 17}, {x: 7, y: 19}, {x: 8, y: 20}, {y: 21, x: 8}, {y: 21, x: 10}, {x: 10, y: 20}, {x: 14, y: 18}, {x: 22, y: 16}, {x: 30, y: 15}, {x: 30, y: 11}], [{x: 20, y: 9}, {x: 26, y: 8}, {x: 30, y: 7}, {y: 2, x: 30}, {y: 2, x: 21}, {x: 21, y: 3}, {x: 16, y: 4}, {x: 10, y: 6}, {x: 4, y: 9}, {x: 3, y: 11}, {x: 4, y: 12}, {x: 4, y: 13}, {x: 6, y: 14}, {y: 15, x: 6}, {y: 15, x: 8}, {x: 8, y: 14}, {x: 9, y: 13}, {x: 13, y: 11}]]}])
    end

    it "merge mode (example 8 preview)" do
      #        ---------*----------
      chunk = "00000000000000000000" \
              "00000000000000000000" \
              "00        0       00" \
              "00        0       00" \
              "00000000000000000000" \
              "00        0       00" \
              "00        0       00" \
              "00000000000000000000" \
              "00000000000000000000"
      result = @polygon_finder_class.new(
        bitmap: @bitmap_class.new(chunk, 20),
        matcher: @matcher,
        options: {number_of_tiles: 2, versus: :o, compress: {uniq: true, linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 9, y: 0}, {x: 19, y: 0}, {x: 19, y: 8}, {x: 9, y: 8}, {x: 0, y: 8}, {x: 0, y: 0}], inner: [[{x: 1, y: 2}, {x: 1, y: 3}, {x: 10, y: 3}, {x: 10, y: 2}], [{x: 1, y: 5}, {x: 1, y: 6}, {x: 10, y: 6}, {x: 10, y: 5}], [{x: 18, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 18, y: 3}], [{x: 18, y: 5}, {x: 10, y: 5}, {x: 10, y: 6}, {x: 18, y: 6}]]}])
    end

    it "merge mode (example 8 vertical)" do
      up = "00000000000000000000" \
            "00000000000000000000" \
            "00        0       00"
      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 20),
        @matcher,
        nil,
        {versus: :o, bounds: true, strict_bounds: true}).process_info

      down = "00        0       00" \
              "00        0       00" \
              "00        0       00" \
              "00000000000000000000" \
              "00000000000000000000"
      finder = @simple_polygon_finder.new(@bitmap_class.new(down, 20),
        @matcher,
        nil,
        {versus: :o, bounds: true, strict_bounds: true})
      result_down = finder.process_info

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(20)
      expect(result.metadata[:height]).to eq(7)
      expect(result.points).to eq([{outer: [{x: 19, y: 1}, {x: 19, y: 2}, {x: 19, y: 3}, {x: 19, y: 4}, {x: 19, y: 5}, {x: 19, y: 6}, {x: 0, y: 6}, {x: 0, y: 5}, {x: 0, y: 4}, {x: 0, y: 3}, {x: 0, y: 2}, {x: 0, y: 1}, {x: 0, y: 0}, {x: 19, y: 0}], inner: [[{y: 1, x: 18}, {y: 1, x: 10}, {x: 10, y: 3}, {x: 10, y: 4}, {y: 5, x: 10}, {y: 5, x: 18}, {x: 18, y: 4}, {x: 18, y: 3}], [{y: 1, x: 10}, {y: 1, x: 1}, {x: 1, y: 3}, {x: 1, y: 4}, {y: 5, x: 1}, {y: 5, x: 10}, {x: 10, y: 4}, {x: 10, y: 3}]]}])
    end

    it "merge mode (example 9 vertical)" do
      up =
        "        00000000                                      0000       " \
        "       000     00                                    0000        " \
        "      000       000                                 0000       0 " \
        "     000          000                             0000 00      0 " \
        "    00000          0000                        00000    00     0 " \
        "   000  00            0000                  000000      000    0 " \
        "  000    000            00000000      000000000          000   00" \
        "0000      000              0000000000000000               00   00"
      mid =
        "0000      000              0000000000000000               00   00" \
        "000         000                  00                     00000  00" \
        " 00          0000                 0                   000  00  00" \
        "  000          0000               0                 0000    00 00" \
        "   000           0000             0              00000      00000" \
        "    000            00000          0           000000         0000" \
        "      000            000000000    0       0000000             000"

      down =
        "      000            000000000    0       0000000             000" \
        "       000               00000000000000000000               00000" \
        "         000                    0000000                   0000 00" \
        "           000                    0                     0000   00" \
        "            0000                  0                   0000     00" \
        "              00000              00                00000       00" \
        "                 00000            0             000000         0 " \
        "                    000000        0        00000000            0 " \
        "                       000000000000000000000000                0 " \
        "                           000000000000000                     0 " \
        "                                                               0 " \
        "                                                               0 "

      result_up = @simple_polygon_finder.new(@bitmap_class.new(up, 65),
        @matcher,
        nil,
        {versus: :a, bounds: true, strict_bounds: true}).process_info

      result_mid = @simple_polygon_finder.new(@bitmap_class.new(mid, 65),
        @matcher,
        nil,
        {versus: :a, bounds: true, strict_bounds: true}).process_info

      result_down = @simple_polygon_finder.new(@bitmap_class.new(down, 65),
        @matcher,
        nil,
        {versus: :a, bounds: true, strict_bounds: true}).process_info

      step_finder = @vertical_merger.new(options: {compress: {uniq: true, linear: true}})
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_mid)
      step_finder.add_tile(result_down)

      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(65)
      expect(result.metadata[:height]).to eq(25)
      expect(result.points).to eq([{outer: [{x: 7, y: 1}, {x: 2, y: 6}, {x: 0, y: 7}, {x: 0, y: 8}, {x: 4, y: 12}, {x: 6, y: 13}, {x: 7, y: 14}, {x: 11, y: 16}, {x: 12, y: 17}, {x: 14, y: 18}, {x: 23, y: 21}, {x: 27, y: 22}, {x: 41, y: 22}, {x: 46, y: 21}, {x: 50, y: 20}, {x: 53, y: 19}, {x: 61, y: 15}, {y: 14, x: 61}, {y: 14, x: 63}, {x: 63, y: 24}, {x: 63, y: 19}, {x: 64, y: 18}, {x: 64, y: 6}, {x: 63, y: 2}, {x: 63, y: 5}, {y: 11, x: 63}, {y: 11, x: 61}, {x: 61, y: 10}, {x: 60, y: 9}, {x: 60, y: 8}, {x: 59, y: 7}, {x: 59, y: 6}, {x: 55, y: 2}, {x: 57, y: 0}, {x: 54, y: 0}, {x: 52, y: 2}, {x: 50, y: 3}, {x: 44, y: 5}, {x: 38, y: 6}, {y: 7, x: 38}, {y: 7, x: 31}, {x: 31, y: 6}, {x: 25, y: 5}, {x: 22, y: 4}, {x: 16, y: 1}, {x: 15, y: 0}, {x: 8, y: 0}], inner: [[{x: 6, y: 12}, {x: 4, y: 10}, {x: 2, y: 9}, {x: 2, y: 8}, {x: 5, y: 5}, {y: 4, x: 5}, {y: 4, x: 8}, {x: 8, y: 5}, {x: 10, y: 7}, {x: 12, y: 8}, {x: 13, y: 9}, {x: 19, y: 12}, {x: 25, y: 14}, {x: 32, y: 15}, {x: 34, y: 16}, {x: 34, y: 17}, {x: 33, y: 18}, {x: 34, y: 19}, {y: 21, x: 34}, {y: 21, x: 25}, {x: 25, y: 20}, {x: 21, y: 19}, {x: 15, y: 17}, {x: 9, y: 14}], [{x: 23, y: 12}, {x: 20, y: 11}, {x: 12, y: 7}, {x: 11, y: 6}, {x: 9, y: 5}, {x: 7, y: 3}, {x: 9, y: 1}, {y: 0, x: 9}, {y: 0, x: 15}, {x: 15, y: 1}, {x: 16, y: 2}, {x: 18, y: 3}, {x: 19, y: 4}, {x: 22, y: 5}, {x: 24, y: 6}, {x: 27, y: 7}, {x: 33, y: 8}, {x: 34, y: 9}, {x: 34, y: 12}, {y: 14, x: 34}, {y: 14, x: 29}], [{x: 34, y: 12}, {x: 34, y: 8}, {x: 42, y: 7}, {x: 46, y: 6}, {x: 49, y: 5}, {x: 53, y: 3}, {y: 2, x: 53}, {y: 2, x: 55}, {x: 55, y: 3}, {x: 56, y: 4}, {x: 56, y: 5}, {x: 58, y: 7}, {x: 52, y: 10}, {x: 46, y: 12}, {y: 14, x: 42}, {y: 14, x: 34}], [{x: 51, y: 12}, {x: 55, y: 10}, {x: 56, y: 9}, {y: 8, x: 56}, {y: 8, x: 59}, {x: 59, y: 9}, {x: 60, y: 10}, {x: 60, y: 11}, {x: 61, y: 12}, {x: 60, y: 14}, {x: 54, y: 17}, {x: 48, y: 19}, {x: 43, y: 20}, {y: 21, x: 43}, {y: 21, x: 34}, {x: 34, y: 16}, {x: 38, y: 15}, {x: 44, y: 14}]]}])
    end

    # This test demonstrates how join polygons by their coordinates. Youn need to build some results from scratch by
    # defining polygons each one composed by the outer polyline and a list of inners ones including its bounding box.
    # Finally you need to declare the width and the height of the whole area (tile) inside the metadata hash.
    it "merge mode from existing polygons" do
      result_up = @result.new
      polygons_up = [{
        outer: [{x: 0, y: 0}, {x: 0, y: 4}, {x: 2, y: 4}, {x: 2, y: 2}, {x: 9, y: 2},
                 {x: 9, y: 4}, {x: 11, y: 4}, {x: 11, y: 0}], inner: [],
        bounds: {min_x: 0, max_x: 11, min_y: 0, max_y: 4}
      }]
      polygons_up = @result.to_numpy(polygons_up) if result_up.is_a? Contrek::Cpp::CPPResult
      result_up.polygons = polygons_up
      result_up.metadata = {width: 12, height: 5}

      result_down = @result.new
      polygons_down = [
        {outer: [{x: 0, y: 0}, {x: 0, y: 4}, {x: 11, y: 4}, {x: 11, y: 0}, {x: 9, y: 0},
        {x: 9, y: 2}, {x: 2, y: 2}, {x: 2, y: 0}], inner: [],
         bounds: {min_x: 0, max_x: 11, min_y: 0, max_y: 4}}
]
      polygons_down = @result.to_numpy(polygons_down) if result_down.is_a? Contrek::Cpp::CPPResult
      result_down.polygons = polygons_down
      result_down.metadata = {width: 12, height: 5}

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(12)
      expect(result.metadata[:height]).to eq(9)
      expect(result.points).to eq([{outer: [{x: 0, y: 4}, {x: 0, y: 8}, {x: 11, y: 8},
        {x: 11, y: 4}, {x: 11, y: 0}, {x: 0, y: 0}], inner: [[{x: 2, y: 2}, {x: 9, y: 2}, {x: 9, y: 6}, {x: 2, y: 6}]]}])
    end

    it "merge horizontal" do
      filename = "graphs_300x1024x0.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      color = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      rgb_matcher = @png_not_matcher.new(color.raw)
      polygonfinder = @simple_polygon_finder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}})
      left = polygonfinder.process_info

      filename = "graphs_300x1024x1.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      color = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      rgb_matcher = @png_not_matcher.new(color.raw)
      polygonfinder = @simple_polygon_finder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, bounds: true, compress: {uniq: true, linear: true}})
      right = polygonfinder.process_info

      step_finder = @merger.new
      step_finder.add_tile(left)
      step_finder.add_tile(right)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(599)
      expect(result.metadata[:height]).to eq(1024)
      expect(result.points).to match_expected_polygons("graphs_300x1024.png", number_of_tiles: 2)
    end

    it "merge vertical" do
      filename = "graphs_1024x300x0.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      color = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      rgb_matcher = @png_not_matcher.new(color.raw)
      polygonfinder = @simple_polygon_finder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, bounds: true, strict_bounds: true})
      result_up = polygonfinder.process_info

      filename = "graphs_1024x300x1.png"
      png_bitmap = @png_bitmap_class.new("./spec/files/images/#{filename}")
      color = @color_class.new(r: 255, g: 255, b: 255, a: 255)
      rgb_matcher = @png_not_matcher.new(color.raw)
      polygonfinder = @simple_polygon_finder.new(png_bitmap,
        rgb_matcher,
        nil,
        {versus: :a, bounds: true, strict_bounds: true})
      result_down = polygonfinder.process_info

      step_finder = @vertical_merger.new
      step_finder.add_tile(result_up)
      step_finder.add_tile(result_down)
      result = step_finder.process_info
      expect(result.metadata[:width]).to eq(1024)
      expect(result.metadata[:height]).to eq(599)
      expect(result.points).to match_expected_polygons("graphs_1024x300.png", number_of_tiles: 2)
    end
  end
end
# rubocop:enable Layout/ArrayAlignment, Layout/FirstArrayElementIndentation
