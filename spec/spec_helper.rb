require "contrek"
require "digest"
require "tempfile"

RSpec.configure do |config|
  Dir["./spec/support/**/*.rb"].sort.each { |f| require f }
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def same_image?(path1, path2)
  a = File.open(path1)
  b = File.open(path2)
  a_md5 = Digest::MD5.file(a.path).hexdigest
  b_md5 = Digest::MD5.file(b.path).hexdigest
  a_md5 == b_md5
end
