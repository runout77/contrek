require "rake"

desc "compiles c++ extension"
task :compile do |t|
  Dir.chdir("ext/cpp_polygon_finder") do
    system "ruby", "extconf.rb"
    system "make", "-B"
    system "cp cpp_polygon_finder.so ./../../lib"
  end
end

desc "builds gem"
task :build do |t|
  system "gem", "build"
  system "mv *.gem pkg"
  Dir.chdir("pkg") do
    system "gem install contrek"
  end
end
