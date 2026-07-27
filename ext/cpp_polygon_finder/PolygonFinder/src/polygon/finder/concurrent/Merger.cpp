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

Merger::Merger(int number_of_threads, const Options& options)
: Finder(number_of_threads, options) {
  if (!this->safe()) {
    std::cerr << "[Contrek WARNING] Processing tile with 'unsafe_mode: true'. "
              << "Incompatible result options might lead to unexpected vector geometry.\n";
  }
}

bool Merger::safe() {
  return(!this->options().unsafe_mode);
}

void Merger::add_tile(ProcessResult& result)
{ if (this->height == 0) {
    this->height = result.height;
  } else {
    if (result.height != this->height && safe()) {
      throw std::invalid_argument("All results must have the same height");
    }
  }
  if (this->versus == -1) {
    this->versus = result.versus;
  } else {
    if (this->versus != result.versus && safe()) {
      throw std::invalid_argument("All results must have the same versus option");
    }
  }
  if (const Options* compress = result.options.get_options("compress")) {
    if (this->safe()) {
      if (compress->contains("visvalingam") || compress->contains("raster") || compress->contains("douglas_peucker"))
      { throw std::invalid_argument("Result with not supported postprocessing compression mode");
      }
    }
  }

  int end_x = this->current_x + result.width;
  Tile* tile = new Tile(this, this->current_x, end_x, std::to_string(tiles_.size()), Benchmarks {0, 0});
  tile->assign_raw_polygons(result.polygons, result.treemap);
  tiles_.queue_push(tile);

  this->maximum_width_ = end_x;
  this->current_x = end_x - 1;
}

ProcessResult* Merger::process_info() {
  this->process_tiles();
  return(Finder::process_info());
}

void Merger::translate(ProcessResult& result, int offset) {
  for (auto& polygon : result.polygons) {
    for (Point& p : polygon.outer) p.x += offset;
    for (auto& seq : polygon.inner) {
      for (Point& p : seq) p.x += offset;
    }
    polygon.bounds.min_x += offset;
    polygon.bounds.max_x += offset;
  }
}
