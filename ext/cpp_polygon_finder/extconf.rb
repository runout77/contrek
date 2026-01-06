require "mkmf-rice"

# rubocop:disable Style/GlobalVars

$CXXFLAGS << " -std=c++17 -pthread -march=native -DNDEBUG -Ofast -flto -g -fno-omit-frame-pointer"
$CFLAGS << " -std=c99 -pthread -march=native -DNDEBUG -Ofast -flto -g -fno-omit-frame-pointer"
$LDFLAGS << " -lz -lstdc++ -flto -pthread"

$objs = [
  "cpp_polygon_finder.o",
  "PolygonFinder/src/polygon/bitmaps/spng.o"
]

create_makefile "cpp_polygon_finder"

# rubocop:enable Style/GlobalVars
