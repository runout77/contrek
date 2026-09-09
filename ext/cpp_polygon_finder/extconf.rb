# frozen_string_literal: true

require "mkmf-rice"

has_tcmalloc = find_library("tcmalloc", "malloc")
has_tiff = have_library("tiff", "TIFFOpen", "tiffio.h")
has_geotiff = has_tiff && have_library("geotiff", "XTIFFOpen", "geotiff/xtiffio.h")

# rubocop:disable Style/GlobalVars

$CXXFLAGS << " -std=c++17 -pthread -march=native -DNDEBUG -Ofast -flto"
$CFLAGS << " -std=c11 -pthread -march=native -DNDEBUG -Ofast -flto"

if has_tcmalloc
  $LDFLAGS << " -Wl,--no-as-needed -ltcmalloc"
  puts "tcmalloc linked to gem."
else
  puts "tcmalloc not found; standard malloc will be used."
end

if has_tiff && has_geotiff
  $CXXFLAGS << " -DCONTREK_HAS_TIFF"
  puts "TIFF/GeoTIFF support enabled."
else
  puts "TIFF/GeoTIFF support disabled."
end

$LDFLAGS << " -lz -lstdc++ -flto -pthread"

$objs = [
  "cpp_polygon_finder.o",
  "PolygonFinder/src/polygon/bitmaps/spng.o"
]

create_makefile "cpp_polygon_finder"

# rubocop:enable Style/GlobalVars
