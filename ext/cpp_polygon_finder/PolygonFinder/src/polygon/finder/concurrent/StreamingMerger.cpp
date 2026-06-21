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
  pr->groups = this->moved;
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

  this->write_outer_polygon_start();
  const std::vector<Point>& points = shape->outer_polyline->raw();
  for (size_t i = 0; i < points.size(); ++i) {
    *stream << points[i].y << "," << points[i].x;
    if (i < points.size() - 1) *stream << " ";
  }
  this->write_outer_polygon_end();

  for (const auto& inner_polyline : shape->inner_polylines) {
    this->write_inner_polygon_start();
    const std::vector<Point>& inner_points = inner_polyline->raw();
    for (size_t i = 0; i < inner_points.size(); ++i) {
      *stream << inner_points[i].y << "," << inner_points[i].x;
      if (i < inner_points.size() - 1) *stream << " ";
    }
    this->write_inner_polygon_end();
  }
}

void StreamingMerger::ensure_header() {
  if (stream && stream->tellp() == 0) {
    this->write_header();
  }
}

void StreamingMerger::ensure_footer() {
  if (stream) {
    this->write_footer();
  }
}
