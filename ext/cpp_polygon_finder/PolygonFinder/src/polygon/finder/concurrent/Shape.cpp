/*
 * Shape.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <list>
#include <vector>
#include <string>
#include "Shape.h"
#include "Polyline.h"
#include "ShapePool.h"

Shape::Shape(ShapePool* shape_pool, Polyline* outer_polyline, const std::vector<InnerPolyline*>& inner_polylines)
: outer_polyline(outer_polyline),
  inner_polylines(inner_polylines),
  shape_pool_(shape_pool) {}

void Shape::clear_inner() {
  inner_polylines.clear();
}

void Shape::detach_from_pool() {
  shape_pool_->detach_shape();
}

void Shape::set_parent_shape(Shape* shape) {
  if (this->parent_shape_ != nullptr)
  { auto& v = this->parent_shape_->children_shapes;
    v.erase(std::remove(v.begin(), v.end(), this), v.end());
  }
  this->parent_shape_ = shape;
  if (shape != nullptr)
  { shape->children_shapes.push_back(this);
  }
}

std::string Shape::name() {
  return(this->outer_polyline->named());
}
