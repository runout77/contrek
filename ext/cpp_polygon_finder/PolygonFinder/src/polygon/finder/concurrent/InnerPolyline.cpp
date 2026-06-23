/*
 * InnerPolyline.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <utility>
#include <vector>
#include "InnerPolyline.h"

InnerPolyline::InnerPolyline(std::vector<Point> raw_coordinates, Shape* shape)
  : raw_coordinates_(std::move(raw_coordinates)),
    shape(shape) {}
InnerPolyline::InnerPolyline(Sequence* sequence) {
  this->raw_coordinates_ = sequence->to_vector();
  this->shape = sequence->shape;
}

void InnerPolyline::compute_vertical_bounds()
{ if (!raw_coordinates_.empty()) {
    int min_y = raw_coordinates_[0].y;
    int max_y = raw_coordinates_[0].y;
    for (const auto& pos : raw_coordinates_) {
      if (pos.y < min_y) min_y = pos.y;
      if (pos.y > max_y) max_y = pos.y;
    }
    vertical_bounds_.min = min_y;
    vertical_bounds_.max = max_y;
  }
}
