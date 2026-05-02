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
#include <unordered_set>
#include "VerticalMerger.h"

VerticalMerger::VerticalMerger(int number_of_threads, std::vector<std::string> *options)
: Merger(number_of_threads, options) {
}

void VerticalMerger::add_tile(ProcessResult& result)
{ transpose(result);
  if (this->tiles.size() > 0) {
    translate(result, this->current_x);
  }
  adjust(result);
  Merger::add_tile(result);
}

ProcessResult* VerticalMerger::process_info() {
  ProcessResult* result = Merger::process_info();
  transpose(*result);
  return(result);
}

void VerticalMerger::transpose(ProcessResult& result) {
  std::swap(result.width, result.height);
  std::unordered_set<Point*> seen;
  for (auto& polygon : result.polygons) {
    auto process_p = [&](Point* p) {
      if (p) {
        if (seen.insert(p).second) {
          std::swap(p->x, p->y);
        }
      }
    };
    for (Point* p : polygon.outer) {
      process_p(p);
    }
    for (auto& sequence : polygon.inner) {
      for (Point* p : sequence) {
        process_p(p);
      }
    }
    std::swap(polygon.bounds.min_x, polygon.bounds.min_y);
    std::swap(polygon.bounds.max_x, polygon.bounds.max_y);
  }
}

void VerticalMerger::adjust(ProcessResult& result) {
  for (auto& polygon : result.polygons) {
    if (!polygon.outer.empty()) {
      std::rotate(polygon.outer.begin(), polygon.outer.begin() + 1, polygon.outer.end());
    }
    for (auto& sequence : polygon.inner) {
      if (!sequence.empty()) {
        std::rotate(sequence.begin(), sequence.begin() + 1, sequence.end());
      }
    }
  }
}
