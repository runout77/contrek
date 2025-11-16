require "json"

RSpec::Matchers.define :match_expected_polygons do |label,
                                                    number_of_tiles: 1,
                                                    draw_to_image: nil,
                                                    store_coordinates: false,
                                                    additional_files_path: []|
  diffable
  attr_reader :expected, :actual
  match do |actual|
    @actual = actual

    basename = label.to_s
    path = File.join(["spec", "files", "coordinates"] + additional_files_path + ["#{basename}_w#{number_of_tiles}.json"])
    File.write(path, JSON.generate(@actual)) if store_coordinates
    raise "Expected coordinates file not found: #{path}" unless File.exist?(path)

    @expected = JSON.parse(File.read(path), symbolize_names: true)

    if draw_to_image
      Contrek::Bitmaps::Painting.direct_draw_polygons(@actual, draw_to_image)
      draw_to_image.save(File.join(["spec", "files", "stored_samples"] + additional_files_path + ["#{basename}_w#{number_of_tiles}.png"]))
    end

    @actual == @expected
  end

  failure_message do |_actual|
    "expected polygons to match for #{label.inspect} (number_of_tiles: #{number_of_tiles})"
  end

  failure_message_when_negated do |_actual|
    "expected polygons not to match for #{label.inspect}, but they are identical"
  end
end
