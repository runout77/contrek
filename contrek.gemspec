lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "contrek/version"
Gem::Specification.new do |s|
  s.name = "contrek"
  s.version = Contrek::VERSION
  s.summary = "Png image shapes contour finder"
  s.description = "Contrek is a Ruby library (C++ powered) to trace png bitmap areas polygonal contours."
  s.authors = ["Emanuele Cesaroni"]
  s.email = "cesaroni.emanuele77@gmail.com"
  s.homepage = "https://github.com/runout77/contrek"
  s.license = "MIT"
  s.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(pkg|spec)/}) }
  end
  s.metadata = {
    "homepage_uri" => "https://github.com/runout77/contrek"
  }

  s.add_development_dependency "rspec", "~> 3.10"
  s.add_development_dependency "standard", "~> 1.49"
  s.add_dependency "chunky_png", "~> 1.4"
  s.add_dependency "rice", "~> 4.5"

  s.required_ruby_version = ">= 3.0.0"

  s.extensions = %w[ext/cpp_polygon_finder/extconf.rb]
end
