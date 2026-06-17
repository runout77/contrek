/*
 * StreamingMerger.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "StreamingMerger.h"
#include <sstream>
#include <algorithm>
#include <vector>
#include <string>

StreamingMerger::StreamingMerger(int number_of_threads,
                                 std::vector<std::string>* options,
                                 std::ofstream* stream_to,
                                 int total_width, int total_height)
  : VerticalMerger(number_of_threads, options), stream(stream_to), total_width(total_width), total_height(total_height) {
  if (!stream) {
    throw std::invalid_argument("Streaming requires a valid destination output. stream_to cannot be null.");
  }
  if (total_width <= 0 || total_height <= 0) {
    throw std::invalid_argument("Streaming requires valid canvas dimensions (width and height must be > 0).");
  }
}

void StreamingMerger::add_tile(ProcessResult& result, bool flush)
{ VerticalMerger::add_tile(result);
  if (tiles_.size() == 2) {
    this->process_tiles();
    this->tiles_.queue_push(this->whole_tile);
    this->stream_polygons(this->whole_tile, flush);
    this->whole_tile->shapes().shrink_to_fit();
  }
}

ProcessResult* StreamingMerger::process_info() {
  ProcessResult *pr = VerticalMerger::process_info();
  pr->groups =  this->moved;
  return(pr);
}

void StreamingMerger::stream_polygons(Tile* tile, bool flush) {
  ensure_header();
  if (int tile_end_x = tile->end_x(); true) {
    tile->shapes().erase(
      std::remove_if(tile->shapes().begin(), tile->shapes().end(), [this, flush, tile_end_x](Shape* shape) {
        if (flush || shape->outer_polyline->max_x() < (tile_end_x - 1)) {
          this->moved++;
          this->stream_raw_polygon(shape);
          shape->detach_from_pool();
          return true;
        }
        return false;
      }),
      tile->shapes().end());
  }
  stream->flush();
  if (flush) {
    ensure_footer();
  }
}

void StreamingMerger::stream_raw_polygon(const Shape* shape) {
  std::ostringstream outer_oss;
  const std::vector<Point*> points = shape->outer_polyline->raw();
  for (size_t i = 0; i < points.size(); ++i) {
    outer_oss << points[i]->y << "," << points[i]->x;
    if (i < points.size() - 1) outer_oss << " ";
  }
  *stream << svg_outer_polygon_string(outer_oss.str());

  for (const auto& inner_polyline : shape->inner_polylines) {
    std::ostringstream inner_oss;
    const std::vector<Point*> inner_points = inner_polyline->raw();
    for (size_t i = 0; i < inner_points.size(); ++i) {
      inner_oss << inner_points[i]->y << "," << inner_points[i]->x;
      if (i < inner_points.size() - 1) inner_oss << " ";
    }
    *stream << svg_inner_polygon_string(inner_oss.str());
  }
}

void StreamingMerger::ensure_header() {
  if (stream && stream->tellp() == 0) {
    *stream << svg_header_string();
  }
}

void StreamingMerger::ensure_footer() {
  if (stream) {
    *stream << svg_footer_string();
  }
}

std::string StreamingMerger::svg_css() {
  return ".out{fill:none;stroke:red;stroke-width:1;}.in{fill:none;stroke:green;stroke-width:1;}.out:hover{stroke:yellow;}";
}

std::string StreamingMerger::svg_header_string() {
  return "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"" + std::to_string(total_width) +
         "\" height=\"" + std::to_string(total_height) + "\"><style>" + svg_css() + "</style>";
}

std::string StreamingMerger::svg_footer_string() {
  return "</svg>";
}

std::string StreamingMerger::svg_outer_polygon_string(std::string_view points) {
  return "<polygon points=\"" + std::string(points) + "\" class=\"out\"/>";
}

std::string StreamingMerger::svg_inner_polygon_string(std::string_view points) {
  return "<polygon points=\"" + std::string(points) + "\" class=\"in\"/>";
}
