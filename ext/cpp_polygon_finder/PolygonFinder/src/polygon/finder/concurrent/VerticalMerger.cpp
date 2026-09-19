/*
 * VerticalMerger.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <utility>
#include "VerticalMerger.h"

VerticalMerger::VerticalMerger(int number_of_threads, const Options& options)
: Merger(number_of_threads, options) {
}

void VerticalMerger::add_tile(ProcessResult& result)
{ transpose(result);
  adjust(result);
  if (this->tiles_.size() > 0) {
    translate(result, this->current_x);
  }
  Merger::add_tile(result);
}

ProcessResult* VerticalMerger::process_info() {
  ProcessResult* result = Merger::process_info();
  transpose(*result);
  return(result);
}

void VerticalMerger::transpose(ProcessResult& result) {
  std::swap(result.width, result.height);
  for (auto& polygon : result.polygons) {
    for (Point& p : polygon.outer) {
      std::swap(p.x, p.y);
    }
    for (auto& sequence : polygon.inner) {
      for (Point& p : sequence) {
        std::swap(p.x, p.y);
      }
    }
    std::swap(polygon.bounds.min_x, polygon.bounds.min_y);
    std::swap(polygon.bounds.max_x, polygon.bounds.max_y);
  }
}

void VerticalMerger::adjust(ProcessResult& result) {
  const int tile_width = result.width;
  const auto number_of_tiles = this->tiles_.size();

  for (auto& polygon : result.polygons) {
    const auto& bounds = polygon.bounds;
    const bool needs_left = number_of_tiles > 0 && bounds.min_x == 0;
    const bool needs_right = bounds.max_x == tile_width;

    if (!needs_left && !needs_right) {
      continue;
    }

    auto& sequence = polygon.outer;
    auto best = sequence.end();
    for (auto it = sequence.begin(); it != sequence.end(); ++it) {
      if (it->y != bounds.min_y) {
        continue;
      }
      if (best == sequence.end() ||
         (result.versus == Node::A ? it->x > best->x : it->x < best->x)) {
        best = it;
      }
    }

    if (best != sequence.end() && best != sequence.begin()) {
      std::rotate(sequence.begin(), best, sequence.end());
    }
  }
}
