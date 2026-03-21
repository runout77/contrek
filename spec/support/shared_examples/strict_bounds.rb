RSpec.shared_examples "strict_bounds" do
  describe "simple cases" do
    it "strict bounds mode versus o up" do
      chunk = "                " \
              "   000  111     " \
              " 222222222222   " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {versus: :o, named_sequences: true, strict_bounds: true}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 5, y: 1}, {x: 5, y: 2}, {x: 8, y: 2}, {x: 8, y: 1}, {x: 10, y: 1}, {x: 12, y: 2}, {x: 1, y: 2}, {x: 3, y: 1}], inner: []}])
    end

    it "strict bounds mode versus o down" do
      chunk = "                " \
              " 000000000000   " \
              "   111  222     " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {versus: :o, named_sequences: true, strict_bounds: true}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 12, y: 1}, {x: 10, y: 2}, {x: 8, y: 2}, {x: 8, y: 1}, {x: 5, y: 1}, {x: 5, y: 2}, {x: 3, y: 2}, {x: 1, y: 1}], inner: []}])
    end

    it "strict bounds mode versus a up" do
      chunk = "                " \
              "   000  111     " \
              " 222222222222   " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {named_sequences: true, strict_bounds: true}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 1, y: 2}, {x: 12, y: 2}, {x: 10, y: 1}, {x: 8, y: 1}, {x: 8, y: 2}, {x: 5, y: 2}, {x: 5, y: 1}], inner: []}])
    end

    it "strict bounds mode versus o down" do
      chunk = "                " \
              " 000000000000   " \
              "   111  222     " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {named_sequences: true, strict_bounds: true}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 1, y: 1}, {x: 3, y: 2}, {x: 5, y: 2}, {x: 5, y: 1}, {x: 8, y: 1}, {x: 8, y: 2}, {x: 10, y: 2}, {x: 12, y: 1}], inner: []}])
    end

    it "strict bounds mode inner versus o up" do
      chunk = "00000000000000  " \
              "11          22  " \
              "33 444  555 66  " \
              "77777777777777  " \
              "88888888888888  " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {versus: :o, named_sequences: true, strict_bounds: true, compress: {linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 13, y: 0}, {x: 13, y: 4}, {x: 0, y: 4}, {x: 0, y: 0}], inner: [[{x: 12, y: 1}, {x: 12, y: 0}, {x: 1, y: 0}, {x: 1, y: 3}, {x: 3, y: 3}, {x: 3, y: 2}, {x: 5, y: 2}, {x: 5, y: 3}, {x: 8, y: 3}, {x: 8, y: 2}, {x: 10, y: 2}, {x: 10, y: 3}, {x: 12, y: 3}, {x: 12, y: 2}]]}])
    end

    it "strict bounds mode inner versus a up" do
      chunk = "00000000000000  " \
              "11          22  " \
              "33 444  555 66  " \
              "77777777777777  " \
              "88888888888888  " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {named_sequences: true, strict_bounds: true, compress: {linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 4}, {x: 13, y: 4}, {x: 13, y: 0}], inner: [[{x: 1, y: 1}, {x: 1, y: 0}, {x: 12, y: 0}, {x: 12, y: 3}, {x: 10, y: 3}, {x: 10, y: 2}, {x: 8, y: 2}, {x: 8, y: 3}, {x: 5, y: 3}, {x: 5, y: 2}, {x: 3, y: 2}, {x: 3, y: 3}, {x: 1, y: 3}, {x: 1, y: 2}]]}])
    end

    it "strict bounds mode inner versus o down" do
      chunk = "00000000000000  " \
              "77777777777777  " \
              "33 444  555 66  " \
              "11          22  " \
              "88888888888888  " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {versus: :o, named_sequences: true, strict_bounds: true, compress: {linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 13, y: 0}, {x: 13, y: 4}, {x: 0, y: 4}, {x: 0, y: 0}], inner: [[{x: 12, y: 2}, {x: 12, y: 1}, {x: 10, y: 1}, {x: 10, y: 2}, {x: 8, y: 2}, {x: 8, y: 1}, {x: 5, y: 1}, {x: 5, y: 2}, {x: 3, y: 2}, {x: 3, y: 1}, {x: 1, y: 1}, {x: 1, y: 4}, {x: 12, y: 4}, {x: 12, y: 3}]]}])
    end

    it "strict bounds mode inner versus a down" do
      chunk = "00000000000000  " \
              "77777777777777  " \
              "33 444  555 66  " \
              "11          22  " \
              "88888888888888  " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {named_sequences: true, strict_bounds: true, compress: {linear: true}}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 0, y: 0}, {x: 0, y: 4}, {x: 13, y: 4}, {x: 13, y: 0}], inner: [[{x: 1, y: 2}, {x: 1, y: 1}, {x: 3, y: 1}, {x: 3, y: 2}, {x: 5, y: 2}, {x: 5, y: 1}, {x: 8, y: 1}, {x: 8, y: 2}, {x: 10, y: 2}, {x: 10, y: 1}, {x: 12, y: 1}, {x: 12, y: 4}, {x: 1, y: 4}, {x: 1, y: 3}]]}])
    end

    it "strict bounds mode versus o up single pixel" do
      chunk = "                " \
              "   0  1         " \
              " 222222222222   " \
              " 222222222222   " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {versus: :o, strict_bounds: true, named_sequences: true}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 3, y: 1}, {x: 3, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}, {x: 6, y: 1}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 1, y: 3}, {x: 1, y: 2}, {x: 3, y: 1}], inner: []}])
    end

    it "strict bounds mode versus o up single pixel" do
      chunk = "   0  1         " \
              "   0  1         " \
              " 222222222222   " \
              " 222222222222   " \
              "                "
      result = @polygon_finder_class.new(
        @bitmap_class.new(chunk, 16),
        @matcher, nil, {versus: :o, strict_bounds: true, named_sequences: true}
      ).process_info
      expect(result.points).to eq([{outer: [{x: 3, y: 0}, {x: 3, y: 1}, {x: 3, y: 2}, {x: 6, y: 2}, {x: 6, y: 1}, {x: 6, y: 0}, {x: 6, y: 0}, {x: 6, y: 1}, {x: 12, y: 2}, {x: 12, y: 3}, {x: 1, y: 3}, {x: 1, y: 2}, {x: 3, y: 1}, {x: 3, y: 0}], inner: []}])
    end
  end
end
