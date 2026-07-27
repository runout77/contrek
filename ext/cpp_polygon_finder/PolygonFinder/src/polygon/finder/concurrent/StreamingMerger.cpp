/*
 * StreamingMerger.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "StreamingMerger.h"
#include "FakeCluster.h"
#include <sstream>
#include <algorithm>
#include <vector>
#include <string>
#include <utility>
#include <list>

StreamingMerger::StreamingMerger(int number_of_threads,
                                 const Options& options,
                                 std::ofstream* stream_to)
  : VerticalMerger(number_of_threads, options), stream(stream_to) {
  if (!stream) {
    throw std::invalid_argument("Streaming requires a valid destination output. stream_to cannot be null.");
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

  const int safe_boundary_x = tile->end_x() - 1;
  auto& shapes = tile->shapes();
  std::list<Polygon> polygons_to_stream;
  shapes.erase(
    std::remove_if(shapes.begin(), shapes.end(), [this, flush, safe_boundary_x, &polygons_to_stream](Shape* shape) {
      const bool is_ready = flush || (shape->outer_polyline->max_x() < safe_boundary_x);
      if (is_ready) {
        this->moved++;
        polygons_to_stream.push_back(std::move(shape->to_raw_polygon()));
        shape->detach_from_pool();
        return true;
      }
      return false;
    }),
    shapes.end()
  );
  if (this->options().any_compression() && !polygons_to_stream.empty()) {
    FakeCluster fake_cluster(polygons_to_stream, this->options());
    fake_cluster.compress_coords(polygons_to_stream, this->options());
  }
  for (Polygon& polygon : polygons_to_stream) {
    this->stream_raw_polygon(std::move(polygon));
  }

  stream->flush();

  if (flush) {
    ensure_footer();
  }
}

void StreamingMerger::stream_raw_polygon(const Polygon& polygon) {
  std::ostringstream outer_oss;

  this->write_outer_polygon_start();
  const std::vector<Point>& points = polygon.outer;
  for (size_t i = 0; i < points.size(); ++i) {
    *stream << points[i].y << "," << points[i].x;
    if (i < points.size() - 1) *stream << " ";
  }
  this->write_outer_polygon_end();

  for (const std::vector<Point>& inner_points : polygon.inner) {
    this->write_inner_polygon_start();
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
