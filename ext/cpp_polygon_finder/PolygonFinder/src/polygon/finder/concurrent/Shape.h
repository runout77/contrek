/*
 * Shape.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <list>
#include <iostream>
#include <vector>
#include "InnerPolyline.h"

class Point;
class Polyline;
class Shape {
 public:
  Shape(Polyline* outer_polyline, const std::vector<InnerPolyline*>& inner_polylines);
  Polyline* outer_polyline = nullptr;
  std::vector<InnerPolyline*> inner_polylines;
  Shape* merged_to_shape = nullptr;
  InnerPolyline* parent_inner_polyline = nullptr;
  std::vector<Shape*> children_shapes;
  void clear_inner();
  bool reassociation_skip = false;
  Shape* parent_shape() { return parent_shape_; }
  void set_parent_shape(Shape*);
 private:
  Shape* parent_shape_ = nullptr;
};
