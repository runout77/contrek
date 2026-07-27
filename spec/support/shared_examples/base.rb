# frozen_string_literal: true

RSpec.shared_examples "base" do
  describe "base cases" do
    it "precise tracing test 1" do
      chunk = "                " \
                 " AAAA           " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {named_sequences: true, bounds: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("A")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(3)
      expect(result.metadata[:options]).to eq({bounds: true, named_sequences: true})
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, named_sequences: true, bounds: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("A")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 2" do
      chunk = "                " \
                 " AAAA           " \
                 " BBBB           " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(4)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 3" do
      chunk = "                " \
                 " AAAA           " \
                 "  BBB           " \
                 "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 4" do
      chunk = "                " \
                 " AAAAA          " \
                 "  BBB           " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(4)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 5" do
      chunk = "                " \
                 "  AAA           " \
                 " BBBBB          " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.metadata[:width]).to eq(16)
      expect(result.metadata[:height]).to eq(4)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 6" do
      chunk = "                " \
                 "  A  C          " \
                 " BBBBBB         " \
                 "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 7" do
      chunk = "                " \
                 "  A G           " \
                 " BBBBB          " \
                 "CCCCCCC         " \
                 " DDDDD          " \
                 "  E F           "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("ABGBCDFDEDCBA")
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 8" do
      chunk = "                " \
                 " AAAAA          " \
                 " B   F          " \
                 " C   E          " \
                 " DDDDD          " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 9" do
      chunk = "                " \
                 " AAAAA          " \
                 " B   H          " \
                 " CC GG          " \
                 " D   F          " \
                 " EEEEE          " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 10" do
      chunk = "                " \
                 " AAAAAA         " \
                 " B CC D         " \
                 " E XX F         " \
                 " E    F         " \
                 " GGGGGG         " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 11" do
      chunk = "                " \
                 " AAAAAA         " \
                 " B    D         " \
                 " E XX F         " \
                 " E CC F         " \
                 " GGGGGG         " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 12" do
      chunk = "                " \
                 " A   B          " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {named_sequences: true, bounds: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("A-B")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {compress: {raster: true}}
      ).process_info
      expect(result.points).to eq([{inner: [],
                                    outer: [{x: 1, y: 1}, {x: 1, y: 1}, {x: 1, y: 1}, {x: 1, y: 1}]},
        {inner: [],
         outer: [{x: 5, y: 1}, {x: 5, y: 1}, {x: 5, y: 1}, {x: 5, y: 1}]}])

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, named_sequences: true}
      ).process_info
      expect(result.metadata[:named_sequence]).to eq("A-B")
      expect(result.metadata[:groups]).to eq(2)
      expect(result.points).to match_expected_json(addons: [:o])

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, compress: {raster: true}}
      ).process_info
      expect(result.points).to eq([{inner: [],
                                    outer: [{x: 1, y: 1}, {x: 1, y: 1}, {x: 1, y: 1}, {x: 1, y: 1}]},
        {inner: [],
         outer: [{x: 5, y: 1}, {x: 5, y: 1}, {x: 5, y: 1}, {x: 5, y: 1}]}])
    end

    it "precise tracing test 13" do
      chunk = "                " \
                 " AAAAAAA        " \
                 " B     N        " \
                 " C 111 M        " \
                 " DDD 3 L        " \
                 " E 222 I        " \
                 " F     H        " \
                 " GGGGGGG        "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true, compress: {linear: true}}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {linear: true}}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end

    it "precise tracing test 14 (raster reduction)" do
      chunk = "                " \
                 " AAAAA          " \
                 " AAAAA          " \
                 " AA AA          " \
                 " AAAAA          " \
                 " AAAAA          " \
                 "                "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil, {compress: {raster: true}}
      ).process_info
      expect(result.metadata[:versus]).to eq :a
      expect(result.points).to eq([{
        outer: [{x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 1, y: 4}, {x: 1, y: 5}, {x: 1, y: 5},
          {x: 5, y: 5}, {x: 5, y: 5}, {x: 5, y: 4}, {x: 5, y: 3}, {x: 5, y: 2}, {x: 5, y: 1}],
        inner: [[{x: 2, y: 2}, {x: 4, y: 2}, {x: 4, y: 4}, {x: 2, y: 4}]]
      }])

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, compress: {raster: true}}
      ).process_info
      expect(result.metadata[:versus]).to eq :o
      expect(result.points).to eq([{
        outer: [{x: 5, y: 1}, {x: 5, y: 2}, {x: 5, y: 3}, {x: 5, y: 4}, {x: 5, y: 5}, {x: 5, y: 5},
          {x: 1, y: 5}, {x: 1, y: 5}, {x: 1, y: 4}, {x: 1, y: 3}, {x: 1, y: 2}, {x: 1, y: 1}],
        inner: [[{x: 4, y: 2}, {x: 2, y: 2}, {x: 2, y: 4}, {x: 4, y: 4}]]
      }])
    end

    it "precise tracing test 15 (douglas peucker reduction)" do
      chunk = "                " \
                 "    0           " \
                 "   000          " \
                 "  00000         " \
                 " 0000000        " \
                 "  00000         " \
                 "   000          " \
                 "    0           "

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {bounds: true, compress: {douglas_peucker: true}}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json

      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher,
        nil,
        {versus: :o, bounds: true, compress: {douglas_peucker: true}}
      ).process_info
      expect(result.metadata[:groups]).to eq(1)
      expect(result.points).to match_expected_json(addons: [:o])
    end
  end
end
