# frozen_string_literal: true

require "json"

RSpec::Matchers.define :match_expected_polygons do |label,
                                                    number_of_tiles: 1,
                                                    draw_to_image: nil,
                                                    draw_points: nil,
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
      Contrek::Bitmaps::Painting.direct_draw_polygons(draw_points || @actual, draw_to_image)
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

RSpec::Matchers.define :match_expected_stream do |label,
                                                 extension:, number_of_tiles: 1,
                                                 store_stream: false,
                                                 additional_files_path: []|
  diffable
  attr_reader :expected, :actual
  match do |actual|
    @actual = actual

    basename = label.to_s
    path = File.join(["spec", "files", "streams"] + additional_files_path + ["#{basename}_w#{number_of_tiles}.#{extension}"])
    File.write(path, @actual) if store_stream
    raise "Expected stream file not found: #{path}" unless File.exist?(path)

    @expected = File.read(path)

    @actual == @expected
  end

  failure_message do |_actual|
    "expected stream file to match for #{label.inspect} (number_of_tiles: #{number_of_tiles})"
  end

  failure_message_when_negated do |_actual|
    "expected stream file not to match for #{label.inspect}, but they are identical"
  end
end

RSpec::Matchers.define :match_expected_json do |store_json: false, addons: []|
  diffable

  match do |actual|
    path = fixture_path(addons:)

    actual_compact = actual.to_json

    File.write(path, actual_compact) if store_json
    raise "Expected json file not found: #{path}" unless File.exist?(path)

    expected_compact = File.read(path)

    @actual = JSON.pretty_generate(JSON.parse(actual_compact))
    @expected = JSON.pretty_generate(JSON.parse(expected_compact))

    JSON.parse(actual_compact) == JSON.parse(expected_compact)
  end

  attr_reader :expected

  attr_reader :actual

  failure_message do
    "expected JSON to match fixture"
  end

  failure_message_when_negated do
    "expected JSON not to match fixture, but they are identical"
  end
end
