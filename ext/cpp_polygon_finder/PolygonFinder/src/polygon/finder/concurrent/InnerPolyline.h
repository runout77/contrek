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

class InnerPolyline {
 public:
  explicit InnerPolyline(std::vector<Point*> raw_coordinates, Shape* shape);
  explicit InnerPolyline(Sequence* sequence);
  std::vector<Point*>& raw();
  Sequence* sequence() { return this->sequence_; }
  Bounds& vertical_bounds();
  Shape* shape();
  Shape* assigned_shape = nullptr;
 private:
  std::vector<Point*> raw_coordinates_;
  Sequence* sequence_ = nullptr;
  Shape* shape_;
  Bounds& raw_vertical_bounds();
  Bounds vertical_bounds_;
};
