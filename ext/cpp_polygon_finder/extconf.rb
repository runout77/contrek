require "mkmf-rice"

has_tcmalloc = find_library("tcmalloc", "malloc")

# rubocop:disable Style/GlobalVars

$CXXFLAGS << " -std=c++17 -pthread -march=native -DNDEBUG -Ofast -flto"
$CFLAGS << " -std=c11 -pthread -march=native -DNDEBUG -Ofast -flto"

if has_tcmalloc
  $LDFLAGS << " -Wl,--no-as-needed -ltcmalloc"
  puts "tcmalloc linked to gem."
else
  puts "tcmalloc not found; standard malloc will be used."
end

$LDFLAGS << " -lz -lstdc++ -flto -pthread"

$objs = [
  "cpp_polygon_finder.o",
  "PolygonFinder/src/polygon/bitmaps/spng.o"
]

create_makefile "cpp_polygon_finder"

# rubocop:enable Style/GlobalVars
