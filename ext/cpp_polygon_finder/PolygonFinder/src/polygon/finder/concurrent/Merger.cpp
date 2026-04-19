/*
 * Merger.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <iostream>
#include <string>
#include <vector>
#include "Merger.h"

Merger::Merger(int number_of_threads, std::vector<std::string> *options)
: Finder(number_of_threads, options) {
}

void Merger::add_tile(ProcessResult& result)
{ if (this->height == 0) {
    this->height = result.height;
  }
  int end_x = this->current_x + result.width;
  Tile* tile = new Tile(this, this->current_x, end_x, std::to_string(tiles.size()), Benchmarks {0, 0});
  tile->assign_raw_polygons(result.polygons, result.treemap);
  tiles.queue_push(tile);

  this->maximum_width_ = end_x;
  this->current_x = end_x - 1;
}

ProcessResult* Merger::process_info() {
  this->process_tiles();
  return(Finder::process_info());
}

void Merger::translate(ProcessResult& result, int offset) {
  for (auto& polygon : result.polygons) {
    for (Point* p : polygon.outer) p->x += offset;
    for (const auto& seq : polygon.inner) {
      for (Point* p : seq) p->x += offset;
    }
    polygon.bounds.min_x += offset;
    polygon.bounds.max_x += offset;
  }
}
