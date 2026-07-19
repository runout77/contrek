# frozen_string_literal: true

module SpecHelpers
  def fixture_path(extension: "json", addons: [])
    metadata = RSpec.current_example.metadata
    chain = []
    chain << ([metadata[:description]] + addons).join("_")
    current_group = metadata[:example_group]
    while current_group
      chain << current_group[:description]
      current_group = current_group[:parent_example_group]
    end
    path_segments = chain.reverse[1..].map do |name|
      name.downcase.strip.gsub(/[^a-z0-9]+/i, "_").gsub(/_{2,}/, "_")
    end
    File.join("spec", "files", "fixtures", *path_segments) + ".#{extension}"
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
end
