lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "contrek/version"
Gem::Specification.new do |s|
  s.name = "contrek"
  s.version = Contrek::VERSION
  s.summary = "Fast PNG contour tracing and shape detection for Ruby"
  s.description = "Contrek is a Ruby gem with a C++ core for fast contour tracing and edge detection in PNG images. It extracts polygonal contours from bitmap shapes, enabling image processing, shape analysis, and raster-to-vector workflows such as PNG to SVG conversion."
  s.authors = ["Emanuele Cesaroni"]
  s.email = "cesaroni.emanuele77@gmail.com"
  s.homepage = "https://github.com/runout77/contrek"
  s.licenses = ["MIT", "AGPL-3.0-only"]
  s.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(pkg|spec)/}) }
  end
  s.metadata = {
    "homepage_uri" => "https://github.com/runout77/contrek",
    "source_code_uri" => "https://github.com/runout77/contrek",
    "documentation_uri" => "https://github.com/runout77/contrek#readme",
    "changelog_uri" => "https://github.com/runout77/contrek/blob/main/CHANGELOG.md"
  }

  s.add_development_dependency "rspec", "~> 3.12"
  s.add_development_dependency "standard", "~> 1.51"
  s.add_development_dependency "curses", "~> 1.5", ">= 1.5.3"
  s.add_development_dependency "ruby-prof", "~> 1.7", ">= 1.7.2"

  s.add_dependency "chunky_png", "~> 1.4"
  s.add_dependency "concurrent-ruby", "~> 1.3.5"
  s.add_dependency "rice", "= 4.5.0"

  s.required_ruby_version = ">= 3.0.0"

  s.extensions = %w[ext/cpp_polygon_finder/extconf.rb]
end
