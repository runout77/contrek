/*
 * InnerPolyline.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <optional>
#include "Sequence.h"

class ShapePool;
class InnerPolyline {
 public:
  explicit InnerPolyline(ShapePool* shape_pool, std::vector<Point> raw_coordinates, Shape* shape);
  explicit InnerPolyline(ShapePool* shape_pool, Sequence* sequence);
  std::vector<Point>& raw() { return this->raw_coordinates_; }
  Bounds& vertical_bounds() { return this->vertical_bounds_; }
  Shape* shape = nullptr;
  ShapePool* shape_pool = nullptr;
  void compute_vertical_bounds();

 private:
  std::vector<Point> raw_coordinates_;
  Bounds vertical_bounds_{0, 0};
};
